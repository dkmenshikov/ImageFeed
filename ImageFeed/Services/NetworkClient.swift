//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 12.03.24.
//

import Foundation

struct NetworkClient {
    
    private enum NetworkClientError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
        case decodingError
    }
    
    weak var delegate: NetworkClientDelegate?
    
    private var task: URLSessionDataTask?
    
    mutating func fetch <Response: Decodable>(request: URLRequest, handler: @escaping (Result<Response, Error>) -> Void) {
        let fulfillCompletionOnTheMainThread: (Result<Response, Error>) -> Void = { result in
            DispatchQueue.main.async {
                handler(result)
            }
        }
        if task != nil {
            task?.cancel()
            print("Second fetch while processing the first")
        }
        delegate?.isFetchingNow = true
        task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            delegate?.isFetchingNow = false
            if let error {
                fulfillCompletionOnTheMainThread(.failure(NetworkClientError.urlRequestError(error)))
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode < 200 || response.statusCode >= 300 {
                    fulfillCompletionOnTheMainThread(.failure(NetworkClientError.httpStatusCode(response.statusCode)))
                    return
                } else {
                    guard let data else { return }
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let response = try decoder.decode(Response.self, from: data)
                        fulfillCompletionOnTheMainThread(.success(response))
                    } catch {
                        fulfillCompletionOnTheMainThread(.failure(NetworkClientError.decodingError))
                    }
                }
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkClientError.urlSessionError))
                return
            }
        }
        task?.resume()
    }
}
