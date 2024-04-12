//
//  ProfileImageURL.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 22.03.24.
//

import Foundation

struct ProfileImageURL: Decodable {
    let profileImage: ProfileImage?
}

struct ProfileImage: Decodable {
    let medium: String?
}
