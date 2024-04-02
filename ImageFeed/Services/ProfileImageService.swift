//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 22.03.24.
//

import UIKit

final class ProfileImageService: NetworkClientDelegate {
    
    //    MARK: - Shared instance of singleton
    
    static let shared = ProfileImageService()
    private init() {
        networkClient.delegate = self
    }
    
//    MARK: - Static properties
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
//    MARK: - Public properties
    
    var isFetchingNow: Bool = false {
        didSet {
            print("[LOG][ProfileImageService]: fetching profile image URL:", isFetchingNow ? "START" : "DONE")
        }
    }
    
    private(set) var profileImageURL: String?
    
    //    MARK: - Private properties
    
    private var networkClient = NetworkClient()
    private var tokenStorageService = OAuthTokenStorageService()
    
    //    MARK: - Public methods
    
    func fetchProfileImageURL(username: String, handler: @escaping (Result<String, Error>) -> Void) {
        guard let authToken = tokenStorageService.authToken else { return }
        guard let request = createProfileRequest(token: authToken, username: username) else {
            assertionFailure("nil Request")
            return
        }
        assert(Thread.isMainThread)
        if !isFetchingNow {
            networkClient.fetch(request: request) { [weak self] (result: Result<ProfileImageURL, any Error>) in
                guard let self else { return }
                switch result {
                case .success(let profileImageURLResponse):
                    profileImageURL = profileImageURLResponse.profileImage?.medium
                    handler(.success(profileImageURL ?? ""))
                case .failure(let error):
                    handler(.failure(error))
                }
            }
            NotificationCenter.default
                .post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageURL])
        } else {
            print("[LOG][ProfileImageService]: second fetching while processing the first")
        }
    }
    
    //    MARK: - Private methods
    
    private func createProfileRequest(token: String, username: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.path = WebConstants.publicUserInfoPath + username
        guard let url = urlComponents.url(relativeTo: WebConstants.apiURL) else {
            assertionFailure("Unable to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
