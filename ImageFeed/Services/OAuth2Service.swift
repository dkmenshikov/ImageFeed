//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 5.03.24.
//

import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    private let networkClient = NetworkClient()
    
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
//                    print(oAuthTokenResponse)
                    handler(.success(oAuthTokenResponse.accessToken))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    private func createOAuthTokenURLRequest(code: String?) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.path = Constants.authPath
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
        ]
        guard let url = urlComponents.url(relativeTo: Constants.defaultBaseURL) else {
            assertionFailure("Unable to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
//        print(request)
        return request
    }
}
