//
//  PhotoInfo.swift
//  Unsplash
//
//  Created by Harry Kim on 2020/06/26.
//  Copyright © 2020 sunwoo. All rights reserved.
//

import Foundation

 // MARK: - PhotoInfo
 struct PhotoInfo: Codable {
     let id: String
     let createdAt, updatedAt, promotedAt: Date?
     let width, height: Int
     let color, resultDescription, altDescription: String?
     let urls: Urls
     let links: ResultLinks
     let categories: [String]
     let likes: Int
     let likedByUser: Bool
     let currentUserCollections: [String]
     let user: User

//     enum CodingKeys: String, CodingKey {
//         case id
//         case createdAt = "created_at"
//         case updatedAt = "updated_at"
//         case promotedAt = "promoted_at"
//         case width, height, color
//         case resultDescription = "description"
//         case altDescription = "alt_description"
//         case urls, links, categories, likes
//         case likedByUser = "liked_by_user"
//         case currentUserCollections = "current_user_collections"
//         case user
//     }
 }

 // MARK: - ResultLinks
 struct ResultLinks: Codable {
     let linksSelf, html, download, downloadLocation: String

     enum CodingKeys: String, CodingKey {
         case linksSelf = "self"
         case html, download
         case downloadLocation
     }
 }

 // MARK: - Urls
 struct Urls: Codable {
     let raw, full, regular, small: String
     let thumb: String
 }

 // MARK: - User
 struct User: Codable {
     let id: String?
     let updatedAt: Date?
     let username, name, firstName, lastName: String?
     let twitterUsername: String?
     let portfolioURL: String?
     let bio, location: String?
     let links: UserLinks?
     let profileImage: ProfileImage?
     let instagramUsername: String?
     let totalCollections, totalLikes, totalPhotos: Int?
     let acceptedTos: Bool?

//     enum CodingKeys: String, CodingKey {
//         case id
//         case updatedAt = "updated_at"
//         case username, name
//         case firstName = "first_name"
//         case lastName = "last_name"
//         case twitterUsername = "twitter_username"
//         case portfolioURL = "portfolio_url"
//         case bio, location, links
//         case profileImage = "profile_image"
//         case instagramUsername = "instagram_username"
//         case totalCollections = "total_collections"
//         case totalLikes = "total_likes"
//         case totalPhotos = "total_photos"
//         case acceptedTos = "accepted_tos"
//     }
 }

 // MARK: - UserLinks
 struct UserLinks: Codable {
     let linksSelf, html, photos, likes: String?
     let portfolio, following, followers: String

//     enum CodingKeys: String, CodingKey {
//         case linksSelf = "self"
//         case html, photos, likes, portfolio, following, followers
//     }
 }

 // MARK: - ProfileImage
 struct ProfileImage: Codable {
     let small, medium, large: String
 }
