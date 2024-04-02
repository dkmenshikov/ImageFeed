//
//  ImagesListPhotos.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 2.04.24.
//

import Foundation

final class ImagesListPhotos: NetworkClientDelegate {
    
    init() {
        networkClient.delegate = self
    }
    
    //    MARK: - Public properties
    
    var isFetchingNow: Bool = false {
        didSet {
            print("[LOG][ImagesListService]: fetching images:", isFetchingNow ? "START" : "DONE")
        }
    }
    //    MARK: - Private properties
    
    private let tokenService = OAuthTokenStorageService()
    private var networkClient = NetworkClient()
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    //    MARK: - Public methods
    
//    TODO: - в звмыкании заменить переметр на [Photo], обработать превращение ответа в модель для UI
    
    func fetchPhotosNextPage(handler: @escaping (Result<PhotoListResponseBody, Error>) -> Void) {
        let nextPage = (lastLoadedPage ?? 0) + 1
        guard let token = tokenService.authToken else { return }
        guard let request = createPhotosListRequest(token: token, page: nextPage) else {
            assertionFailure("nil Request")
            return
        }
        print(request.httpMethod, request.url, request.allHTTPHeaderFields)
        
//        TODO: - дописать исключения повторного фетча 
        
        networkClient.fetch(request: request) { [weak self] (result: Result<PhotoListResponseBody, any Error>) in
            guard let self else { return }
            switch result {
            case .success(let photoListResponse):
                print ("SUCCESS")
                print (photoListResponse)
//                TODO: - добавить нотификацию после обновления массива с фото
                handler(.success(photoListResponse))
            case .failure(let error):
                handler(.failure(error))
                print("ERROR")
            }
        }
    }
    
    //    MARK: - Private methods
    
    private func createPhotosListRequest(token: String ,page: Int, photosPerPage: Int = 10) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.path = WebConstants.photosPath
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(photosPerPage)),
        ]
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
