//
//  AuthConfigurations.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 25.04.24.
//

import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL?
    let authURLString: String

    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL?) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: WebConstants.accessKey,
                                 secretKey: WebConstants.secretKey,
                                 redirectURI: WebConstants.redirectURI,
                                 accessScope: WebConstants.accessScope,
                                 authURLString: WebConstants.unsplashAuthorizeURLString,
                                 defaultBaseURL: WebConstants.defaultBaseURL)
    }
}
