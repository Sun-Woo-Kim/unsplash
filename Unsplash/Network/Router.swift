//
//  Router.swift
//  Unsplash
//
//  Created by Harry Kim on 2020/06/25.
//  Copyright © 2020 sunwoo. All rights reserved.
//

import RxCocoa
import RxSwift
import Alamofire

struct Router<T: Codable> {
    private let baseURL = "https://api.unsplash.com/"

    private let url: String
    private let parameters: [String : Any]?
    private let method: HTTPMethod
    private let header: HTTPHeaders?

    init(url: String, method: HTTPMethod = .get, parameters: Encodable? = nil, header: HTTPHeaders? = nil) {
        self.url = url
        self.method = method
        self.parameters = parameters?.dictionary
        self.header = header
    }

    var dataRequest: DataRequest {
        let encoding: URLEncoding
        switch method {
        case .get:
            encoding = URLEncoding.default
        default:
            encoding = URLEncoding.httpBody
        }
        return AF.request(baseURL + url, method: method, parameters: parameters, encoding: encoding, headers: header)
    }
}

extension Router {
    func asObservable() -> Observable<T> {
        return Observable<T>.create{ observer in

            let session = self.dataRequest.responseData { response in

                if let error = response.error {
                    Logger.error(error)
                    observer.onError(error)
                    return
                }

                do {
                    if let data = response.data, let prettyString = data.prettyPrintedJSONString {
                        Logger.info(prettyString)
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                        
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        decoder.dateDecodingStrategy = .formatted(formatter)
                        
                        let value = try decoder.decode(T.self, from: data)
                        observer.onNext(value)
                        observer.onCompleted()
                    } else {
                        Logger.error(RxError.noElements)
                        observer.onError(RxError.noElements)
                    }
                } catch {
                    Logger.error(error)
                    observer.onError(error)
                }
            }

            return Disposables.create { session.cancel() }
        }

    }
}
