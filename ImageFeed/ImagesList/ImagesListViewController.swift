//
//  ViewController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 1.02.24.
//

import Foundation
import Kingfisher
import ProgressHUD
import UIKit

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    
    func updateTableViewAnimated(indexPaths: [IndexPath])
    func cleanImagesList()
    func blockUI(_ block: Bool)
    func configure(presenter: ImagesListPresenterProtocol)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
//    MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
//    MARK: - Presenter
    
    var presenter: ImagesListPresenterProtocol?
    
//    MARK: - Private propeties
    
    private let showSingleImageSegueIdentifier: String = "ShowSingleImage"
    
//    MARK: - Public methods
    
    func configure(presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        presenter.view = self
    }
    
    func cleanImagesList() {
        dismiss(animated: true)
    }
    
    func blockUI(_ block: Bool) {
        if block {
            UIBlockingProgressHUD.show()
        } else {
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func updateTableViewAnimated(indexPaths: [IndexPath]) {
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
//    MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        presenter?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presenter?.viewDidAppear()
    }
    
//    MARK: - Private methods
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 270
        tableView.backgroundColor = .ypBlack
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
//    MARK: - Override methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            let imageURL = presenter?.photos[indexPath.row].largeImageURL
            viewController.imageURL = imageURL
            
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
        guard let imageSize = presenter?.photos[indexPath.row].size else { return CGFloat()}
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter else { return }
        if indexPath.row == presenter.photos.count - 3 {
            presenter.imagesListService.fetchPhotosNextPage()
        }
    }
    
}

//     MARK: - UITableViewDataSource extension

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.photos.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print("[LOG]: Unable to init custom cell")
            return UITableViewCell()
        }
        guard let presenter else { return  UITableViewCell() }
        imageListCell.configCell(with: indexPath, photo: presenter.photos[indexPath.row], delegate: presenter as ImagesListCellDelegate)
        tableView.reloadRows(at: [indexPath], with: .automatic)
        return imageListCell
    }
    
}

