//
//  OAuthTokenStorageService.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 12.03.24.
//

import Foundation

final class OAuthTokenStorageService {
    
    private let userDefaults = UserDefaults.standard
    private let authTokenKey = "authTokenKey"
    
    var authToken: String? {
        get {
            return userDefaults.string(forKey: authTokenKey) ?? nil
        }
        set {
            userDefaults.setValue(newValue, forKey: authTokenKey)
        }
    }
}
