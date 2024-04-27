//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Dmitriy Menshikov on 27.04.24.
//

import ImageFeed
import Foundation

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var isUpdateProfileCalled = false
    var isUpdateAvatarCalled = false
    
    var view: (any ImageFeed.ProfileViewControllerProtocol)?
    
    func logout() {
        
    }
    
    func updateProfileData() {
        isUpdateProfileCalled = true
    }
    
    func updateAvatar() {
        isUpdateAvatarCalled = true
    }
    
    
}
