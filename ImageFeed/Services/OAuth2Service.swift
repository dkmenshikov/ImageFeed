//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 5.03.24.
//

import UIKit

final class OAuth2Service: NetworkClientDelegate {
    
//    MARK: - Shared instance of singleton
    
    static let shared = OAuth2Service()
    private init() {
        networkClient.delegate = self
    }
    
//    MARK: - Public properties
    
    var isFetchingNow: Bool = false {
        didSet {
            print("fetching token:", isFetchingNow ? "START" : "DONE")
        }
    }
    
//    MARK: - Private properties
    
    private var networkClient = NetworkClient()
    private var lastCode: String?
    
//    MARK: - Public methods
    
    func fetchOAuthToken(code: String, handler: @escaping (Result<String, Error>) -> Void) {
        guard let request = createOAuthTokenURLRequest(code: code) else {
            assertionFailure("nil Request")
            return
        }
        assert(Thread.isMainThread)
        if !isFetchingNow || lastCode != code {
            networkClient.fetch(request: request) { (result: Result<OAuthTokenResponseBody, any Error>) in
                switch result {
                case .success(let oAuthTokenResponse):
                    let token = oAuthTokenResponse.accessToken
                    print("TOKEN: ", token)
                    handler(.success(token))
                case .failure(let error):
                    handler(.failure(error))
                }
            }
        } else {
            print ("Second fetch with the same code")
        }
        lastCode = code
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
