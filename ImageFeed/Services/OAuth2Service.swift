//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 5.03.24.
//

import UIKit

final class OAuth2Service {
    
//    MARK: - Shared instance of singleton
    
    static let shared = OAuth2Service()
    private init() {}
    
//    MARK: - Private properties
    
    private let networkClient = NetworkClient()
    
//    MARK: - Public methods
    
    func fetchOAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void) {
        guard let request = createOAuthTokenURLRequest(code: code) else {
            assertionFailure("nil Request")
            return
        }
        networkClient.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let oAuthTokenResponse = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    handler(.success(oAuthTokenResponse.accessToken))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
//    MARK: - Private methods
    
    private func createOAuthTokenURLRequest(code: String?) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.path = WebConstants.authPath
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: WebConstants.accessKey),
            URLQueryItem(name: "client_secret", value: WebConstants.secretKey),
            URLQueryItem(name: "redirect_uri", value: WebConstants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        guard let url = urlComponents.url(relativeTo: WebConstants.defaultBaseURL) else {
            assertionFailure("Unable to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}
