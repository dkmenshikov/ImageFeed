//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 2.04.24.
//

import Foundation

final class ImagesListService: NetworkClientDelegate {
    
    init() {
        networkClient.delegate = self
        fetchPhotosNextPage()
    }
    
    //    MARK: - Public properties
    
    var isFetchingNow: Bool = false {
        didSet {
            print("[LOG][ImagesListService]: fetching images:", isFetchingNow ? "START" : "DONE")
        }
    }
    
    //    MARK: - Static properties
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    //    MARK: - Private properties
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int = 0
    private let dateFormatter = ISO8601DateFormatter()
    private let tokenService = OAuthTokenStorageService()
    private let networkClient = NetworkClient()
    
    //    MARK: - Public methods
    
    func fetchPhotosNextPage() {
        if !isFetchingNow {
            let nextPage = lastLoadedPage + 1
            guard let token = tokenService.authToken else { return }
            guard let request = createPhotosListRequest(token: token, page: nextPage) else {
                assertionFailure("nil Request")
                return
            }
            networkClient.fetch(request: request) { [weak self] (result: Result<PhotoListResponseBody, any Error>) in
                guard let self else { return }
                switch result {
                case .success(let photoListResponse):
                    lastLoadedPage += 1
                    photoListResponse.forEach {
                        guard
                            let thumbURL = URL(string: $0.urls.thumb),
                            let fullURL = URL(string: $0.urls.full) else { return }
                        let date = self.dateFormatter.date(from: $0.createdAt)
                        let newElement = Photo(id: $0.id,
                                               size: CGSize(width: $0.width, height: $0.height),
                                               createdAt: date,
                                               welcomeDescription: $0.description,
                                               thumbImageURL: thumbURL,
                                               largeImageURL: fullURL,
                                               isLiked: $0.likedByUser)
                        if !self.photos.contains(newElement) {
                            self.photos.append(newElement)
                        }
                    }
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.didChangeNotification,
                            object: self,
                            userInfo: ["Photos: ": "appended"])
                case .failure(let error):
                    print("[LOG][ImagesListService]: ", error)
                }
            }
        } else {
            print("[LOG][ImagesListService]: second fetch while processing the first")
            return
        }
    }
    
    func changeLike(photoID: String, isLiked: Bool, completion: @escaping (Result<PhotoLikeChanged, Error>) -> Void) {
        guard let token = tokenService.authToken else { return }
        guard let request = createChangeLikeRequest(token: token, photoID: photoID, isLiked: isLiked) else {
            assertionFailure("nil Request")
            return
        }
        networkClient.fetch(request: request) { [weak self] (result: Result<PhotoLikeChangedResponse, any Error>) in
            guard let self else { return }
            switch result {
            case .success(let response):
                let photo = response.photo
                completion(.success(photo))
            case .failure(let error):
                completion(.failure(error))
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
    
    private func createChangeLikeRequest(token: String, photoID: String, isLiked: Bool) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.path = WebConstants.photosPath + photoID + WebConstants.likePath
        guard let url = urlComponents.url(relativeTo: WebConstants.apiURL) else {
            assertionFailure("Unable to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        if isLiked {
            request.httpMethod = HTTPMethods.delete
        } else {
            request.httpMethod = HTTPMethods.post
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
