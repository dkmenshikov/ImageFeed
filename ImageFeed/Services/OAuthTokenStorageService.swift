//
//  OAuthTokenStorageService.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 12.03.24.
//

import Foundation
import SwiftKeychainWrapper

final class OAuthTokenStorageService {
    
    private let keychainWrapper = KeychainWrapper.standard
    private let authTokenKey = "authTokenKey"
    
    var authToken: String? {
        get {
            return keychainWrapper.string(forKey: authTokenKey) ?? nil
        }
        set {
            guard let newValue else { return }
            keychainWrapper.set(newValue, forKey: authTokenKey)
        }
    }
}

