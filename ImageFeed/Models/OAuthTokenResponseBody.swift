//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 6.03.24.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
}

private enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
}
