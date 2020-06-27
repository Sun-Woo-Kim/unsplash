//
//  PhotoRequest.swift
//  Unsplash
//
//  Created by Harry Kim on 2020/06/26.
//  Copyright © 2020 sunwoo. All rights reserved.
//

import Foundation

// MARK: - PhotoRequest
struct PhotoRequest: Codable {
    var page: Int
    var query: String?
}
