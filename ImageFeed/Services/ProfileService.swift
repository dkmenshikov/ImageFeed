//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 19.03.24.
//

import Foundation

final class ProfileService: NetworkClientDelegate {
    
    //    MARK: - Shared instance of singleton
    
    static let shared = ProfileService()
    private init() {
        networkClient.delegate = self
    }
    
//    MARK: - Public properties
    
    var isFetchingNow: Bool = false {
        didSet {
            print("fetching profile:", isFetchingNow ? "START" : "DONE")
        }
    }
    
    private(set) var profile = ProfileData(username: "", name: "", bio: "")
    
    //    MARK: - Private properties
    
    private var networkClient = NetworkClient()
    private var tokenStorageService = OAuthTokenStorageService()
    
    //    MARK: - Public methods
    
    func fetchProfileData(handler: @escaping (Result<ProfileData, Error>) -> Void) {
        guard let authToken = tokenStorageService.authToken else { return }
        guard let request = createProfileRequest(token: authToken) else {
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
                        let profileResponse = try decoder.decode(ProfileResponseBody.self, from: data)
                        let profileData = ProfileData(username: "@"+profileResponse.username,
                                                      name: profileResponse.name,
                                                      bio: profileResponse.bio ?? "no bio")
                        self.profile = ProfileData(username: "@"+profileResponse.username,
                                              name: profileResponse.name,
                                              bio: profileResponse.bio ?? "no bio")
                        handler(.success(profileData))
                    } catch {
                        handler(.failure(error))
                    }
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        }
    }
    
    //    MARK: - Private methods
    
    private func createProfileRequest(token: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.path = WebConstants.mePath
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
