//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 22.03.24.
//

import Foundation

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
            print("fetching profile image URL:", isFetchingNow ? "START" : "DONE")
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
            networkClient.fetch(request: request) { result in
                switch result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let profileImageURLResponse = try decoder.decode(ProfileImageURL.self, from: data)
                        guard let profileImageURL = profileImageURLResponse.profileImage.small else {
                            print ("no URL in response")
                            return
                        }
                        self.profileImageURL = profileImageURL
                        handler(.success(profileImageURL))
                    } catch {
                        handler(.failure(error))
                    }
                case .failure(let error):
                    handler(.failure(error))
                }
            }
            NotificationCenter.default                                     // 1
                .post(                                                     // 2
                    name: ProfileImageService.didChangeNotification,       // 3
                    object: self,                                          // 4
                    userInfo: ["URL": profileImageURL])                    // 5
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
