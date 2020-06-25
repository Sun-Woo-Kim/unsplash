//
//  SearchRequest.swift
//  Unsplash
//
//  Created by Harry Kim on 2020/06/26.
//  Copyright © 2020 sunwoo. All rights reserved.
//

import Foundation

struct SearchRequest: Codable {
    var page: Int
    var query: String
}
