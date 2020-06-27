//
//  PhotoResponse.swift
//  Unsplash
//
//  Created by Harry Kim on 2020/06/25.
//  Copyright © 2020 sunwoo. All rights reserved.
//

 import Foundation

 // MARK: - PhotoResponse
 struct PhotoResponse: Codable {
     let total, totalPages: Int
     let results: [PhotoInfo]
 }
