//
//  Photo.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 2.04.24.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
