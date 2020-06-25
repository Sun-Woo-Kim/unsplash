//
//  SearchResponse.swift
//  Unsplash
//
//  Created by Harry Kim on 2020/06/25.
//  Copyright © 2020 sunwoo. All rights reserved.
//

 import Foundation

 // MARK: - SearchResponse
 struct SearchResponse: Codable {
     let total, totalPages: Int
     let results: [PhotoInfo]

//     enum CodingKeys: String, CodingKey {
//         case total
//         case totalPages = "total_pages"
//         case results
//     }
 }
