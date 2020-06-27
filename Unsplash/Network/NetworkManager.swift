//
//  NetworkManager.swift
//  Unsplash
//
//  Created by Harry Kim on 2020/06/25.
//  Copyright © 2020 sunwoo. All rights reserved.
//

import Alamofire

class NetworkManager {

    private static let header = HTTPHeaders(["Authorization": "Client-ID UPyKMQByq7T-BM2XYLwP6zyzQ4q9oveKSHe0qfxE2Es"])

    static func getPhotoSearchInfo(request: PhotoRequest) -> Router<PhotoResponse> {
        return Router(url: "search/photos/", parameters: request, header: header)
    }

    static func getPhotoListInfo(request: PhotoRequest) -> Router<[PhotoInfo]> {
        return Router(url: "photos/", parameters: request, header: header)
    }

    static func cancelAllRequest() {
       URLSession.shared.invalidateAndCancel()
    }
}
