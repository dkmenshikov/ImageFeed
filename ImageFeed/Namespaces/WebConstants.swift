//
//  Constants.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 29.02.24.
//

import Foundation

enum WebConstants {
    static let accessKey = "LBpjCt_BRw470HQYYNuakkotMTC2lCWpYB_MYKFVcKw"
    static let secretKey = "wvy1QXHBUtmTYEA4K0wRbxOGhIGFQdFPujchmk8JhpQ"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://unsplash.com/")
    static let apiURL = URL(string: "https://api.unsplash.com/")
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let authPath = "oauth/token"
    static let mePath = "me"
    static let photosPath = "photos/"
    static let publicUserInfoPath = "users/"
    static let likePath = "/like"
}
