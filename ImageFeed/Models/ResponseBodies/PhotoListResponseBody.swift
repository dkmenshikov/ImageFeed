//
//  PhotoListResponseBody.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 2.04.24.
//

import Foundation

struct PhotoInfo: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String
    let description: String?
    let urls: PhotoURLs
    let likedByUser: Bool
}

struct PhotoURLs: Decodable {
    let full: String
    let thumb: String
}

typealias PhotoListResponseBody = [PhotoInfo]

struct PhotoLikeChangedResponse: Decodable {
    let photo: PhotoLikeChanged
}

struct PhotoLikeChanged: Decodable {
    let id: String
    let likedByUser: Bool
}
