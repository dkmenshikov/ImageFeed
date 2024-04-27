//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 27.04.24.
//

import Foundation

public protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set }
    func logout()
    func updateProfileData()
    func updateAvatar()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
//    MARK: - View
    
    weak var view: ProfileViewControllerProtocol?
    
//    MARK: - Private properties
    
    private var profileLogoutService = ProfileLogoutService.shared

//    MARK: - Public methods
    
    func logout() {
        profileLogoutService.logout()
        updateProfileData()
        updateAvatar()
    }
    
    func updateProfileData() {
        let profileService = ProfileService.shared
        let profileData = profileService.profile
        let name = profileData.name
        var nickname = ""
        if profileData.username != "" {
            nickname = "@"+profileData.username
        }
        let bio = profileData.bio
        
        view?.updateProfileData(profile: ProfileData(username: nickname, name: name, bio: bio))
    }
    
    func updateAvatar() {
        let profileImageService = ProfileImageService.shared
        guard
            let profileImageURL = profileImageService.profileImageURL,
            let url = URL(string: profileImageURL)
        else {
            view?.updateAvatar(url: nil)
            return
        }
        view?.updateAvatar(url: url)
    }
    
}
