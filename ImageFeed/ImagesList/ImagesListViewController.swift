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
    
//    MARK: - private propeties
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let showSingleImageSegueIdentifier: String = "ShowSingleImage"
    
    
//    MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
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
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

//     MARK: - UITableViewDelegate extension

extension ImagesListViewController: UITableViewDelegate {
    
    // метод, вызываемый при выделении строки таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
}

//     MARK: - UITableViewDataSource extension

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            print ("Ошибка инициализации кастомной ячейки")
            return UITableViewCell()
        }
        imageListCell.configCell(with: indexPath)
        return imageListCell
    }
    
}

