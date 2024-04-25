//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 25.04.24.
//

import Foundation

protocol AuthHelperprotocol {
    func authRequest() -> URLRequest?
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperprotocol {
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
//    MARK: - Public methods
    
    func authRequest() -> URLRequest? {
        guard let authURL = authURL() else { return nil }
        return URLRequest(url: authURL)
    }
    
    func code(from url: URL) -> String? {
        if
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
//    MARK: - Private methods
    
    private func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: WebConstants.unsplashAuthorizeURLString) else {
            assertionFailure("Invalid Auth URL")
            return nil
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: WebConstants.accessKey),
            URLQueryItem(name: "redirect_uri", value: WebConstants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: WebConstants.accessScope)
         ]
        guard let url = urlComponents.url else {
            assertionFailure("Invalid Query Items")
            return nil
        }
        return url
    }
}
