//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 19.03.24.
//

import Foundation

final class ProfileService {
    
    //    MARK: - Shared instance of singleton
    
    static let shared = ProfileService()
    private init() {
        //        networkClient.delegate = self
    }
    //    MARK: - Private properties
    
    private var networkClient = NetworkClient()
    private var tokenStorageService = OAuthTokenStorageService()
    
    //    MARK: - Public methods
    
    func fetchProfileData(handler: @escaping (Result<ProfileResponseBody, Error>) -> Void) {
        guard let authToken = tokenStorageService.authToken else { return }
        guard let request = createProfileRequest(token: authToken) else {
            assertionFailure("nil Request")
            return
        }
        assert(Thread.isMainThread)
        networkClient.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let profileResponse = try decoder.decode(ProfileResponseBody.self, from: data)
                    handler(.success(profileResponse))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
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
