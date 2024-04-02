//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 12.03.24.
//

import Foundation

class NetworkClient {
    
    private enum NetworkClientError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
        case decodingError
    }
    
    weak var delegate: NetworkClientDelegate?
    
    private var task: URLSessionDataTask?
    
    func fetch <Response: Decodable>(request: URLRequest, handler: @escaping (Result<Response, Error>) -> Void) {
        let fulfillCompletionOnTheMainThread: (Result<Response, Error>) -> Void = { result in
            DispatchQueue.main.async {
                handler(result)
            }
        }
        if task != nil {
            task?.cancel()
            print("[LOG][NetworkClient]: second fetch while processing the first")
        }
        delegate?.isFetchingNow = true
        task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            delegate?.isFetchingNow = false
            defer {
                task = nil
            }
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
//                    print(String(data: data, encoding: .utf8))
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        let response = try decoder.decode(Response.self, from: data)
                        fulfillCompletionOnTheMainThread(.success(response))
                    } catch {
                        print("JSON DECODING FAILURE")
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
