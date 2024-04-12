//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 6.04.24.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    //    MARK: - Shared instance of singleton
    
    static let shared = ProfileLogoutService()
    private init() { }
    
//    MARK: - Delegate
    
    weak var delegate: ProfileLogoutServiceDelegate?
    
    //    MARK: - Public methods
    
    func logout() {
        cleanCookies()
        cleanTokenData()
        cleanProfile()
        cleanImagesList()
    }
    
    //    MARK: - Private methods
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    private func cleanTokenData() {
        let tokenStorageService = OAuthTokenStorageService()
        tokenStorageService.clearTokenInfo()
    }
    
    private func cleanProfile() {
        ProfileService.shared.clearProfileData()
        ProfileImageService.shared.clearProfileImage()
    }
    
    private func cleanImagesList() {
        delegate?.cleanImagesList()
    }
}
