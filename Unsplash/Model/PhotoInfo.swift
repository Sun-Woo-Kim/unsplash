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
 }

 // MARK: - ResultLinks
 struct ResultLinks: Codable {
     let html, download, downloadLocation: String
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
 }

 // MARK: - UserLinks
 struct UserLinks: Codable {
     let linksSelf, html, photos, likes: String?
     let portfolio, following, followers: String
 }

 // MARK: - ProfileImage
 struct ProfileImage: Codable {
     let small, medium, large: String
 }
