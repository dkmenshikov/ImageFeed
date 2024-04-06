//
//  ProfileLikeChangeResponse.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 6.04.24.
//

import Foundation

struct PhotoLikeChangedResponse: Decodable {
    let photo: PhotoLikeChanged
}

struct PhotoLikeChanged: Decodable {
    let id: String
    let likedByUser: Bool
}
