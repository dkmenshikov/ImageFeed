//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 27.04.24.
//

import Foundation
import UIKit

public protocol ImagesListPresenterProtocol: AnyObject, ImagesListCellDelegate {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    var imagesListService: ImagesListService { get set }
    var imagesListServiceObserver: NSObjectProtocol? { get set }
    
    func updateTableViewAnimated()
    func viewDidAppear()
    func viewDidLoad()
}

final class ImagesListPresenter: ImagesListPresenterProtocol, ProfileLogoutServiceDelegate, ImagesListCellDelegate {
    
//    MARK: - View
    
    weak var view: ImagesListViewControllerProtocol?
    
//    MARK: - Public properties
    
    var photos: [Photo] = []
    var imagesListService = ImagesListService()
    var imagesListServiceObserver: NSObjectProtocol?
    
//    MARK: - Public methods
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if newCount != oldCount {
            var indexPaths: [IndexPath] = []
            for i in oldCount..<newCount {
                indexPaths.append(IndexPath(row: i, section: 0))
            }
            view?.updateTableViewAnimated(indexPaths: indexPaths)
        }
    }
    
    func cleanImagesList() {
        photos = []
        view?.cleanImagesList()
    }
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                updateTableViewAnimated()
            }
    }
    
    func viewDidAppear() {
        ProfileLogoutService.shared.delegate = self
    }
    
    func changeLike(indexPath: IndexPath, completion: @escaping (Bool) -> (Void)) {
        view?.blockUI(true)
        imagesListService.changeLike(photoID: photos[indexPath.row].id,
                                     isLiked: photos[indexPath.row].isLiked) { [weak self] (result: Result<PhotoLikeChanged, any Error>) in
            guard let self else { return }
            view?.blockUI(false)
            switch result {
            case .success(let photo):
                self.photos[indexPath.row].isLiked = photo.likedByUser
                completion(true)
            case .failure(let error):
                print("[LOG]: failure of updating like status, \(error)")
                completion(false)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(imagesListServiceObserver)
    }
    
}
