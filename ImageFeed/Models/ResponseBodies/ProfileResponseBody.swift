//
//  ProfileResponseBody.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 19.03.24.
//

import Foundation

struct ProfileResponseBody: Decodable {
    let username: String
    let name: String
    let bio: String?
}
