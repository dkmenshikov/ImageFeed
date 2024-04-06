//
//  ViewController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 1.02.24.
//

import Foundation
import UIKit

final class ImagesListViewController: UIViewController {
    
//    MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
//    MARK: - Private propeties
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let showSingleImageSegueIdentifier: String = "ShowSingleImage"
    
    private var imagesListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    private var imagesListService = ImagesListService()
    
//    MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
    
//    MARK: - Private methods
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 270
        tableView.backgroundColor = .ypBlack
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if newCount != oldCount {
            var indexPaths: [IndexPath] = []
            for i in oldCount..<newCount {
                indexPaths.append(IndexPath(row: i, section: 0))
            }
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
//    MARK: - Override methods
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == showSingleImageSegueIdentifier {
//            guard
//                let viewController = segue.destination as? SingleImageViewController,
//                let indexPath = sender as? IndexPath
//            else {
//                assertionFailure("Invalid segue destination")
//                return
//            }
//            guard let image = UIImage(named: photosName[indexPath.row]) else { return }
//            viewController.image = image
//        } else {
//            super.prepare(for: segue, sender: sender)
//        }
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            guard let image = UIImage(named: photosName[indexPath.row]) else { return }
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

//     MARK: - UITableViewDelegate extension

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
}

//     MARK: - UITableViewDataSource extension

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("[LOG]: Unable to init custom cell")
            return UITableViewCell()
        }
        imageListCell.configCell(with: indexPath, photo: photos[indexPath.row])
        tableView.reloadRows(at: [indexPath], with: .automatic)
        return imageListCell
    }
    
}

