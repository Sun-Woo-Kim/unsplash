//
//  Codable+Extension.swift
//  Unsplash
//
//  Created by Harry Kim on 2020/06/25.
//  Copyright © 2020 sunwoo. All rights reserved.
//

import Foundation

extension Encodable {
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
