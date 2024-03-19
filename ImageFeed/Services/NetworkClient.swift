//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 12.03.24.
//

import Foundation

struct NetworkClient {
    
    private enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
    }
    
    weak var delegate: NetworkClientDelegate?
    
    private var task: URLSessionDataTask?
    
    mutating func fetch (request: URLRequest, handler: @escaping (Result<Data, Error>) -> Void) {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
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
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                return
            }
            if let response = response as? HTTPURLResponse {
                if response.statusCode < 200 || response.statusCode >= 300 {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(response.statusCode)))
                    return
                } else {
                    guard let data else { return }
                    fulfillCompletionOnTheMainThread(.success(data))
                }
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                return
            }
        }
        task?.resume()
    }
}
