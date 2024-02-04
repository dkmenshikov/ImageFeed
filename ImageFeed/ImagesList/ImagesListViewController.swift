//
//  ViewController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 1.02.24.
//

import UIKit

class ImagesListViewController: UIViewController {
    
//    MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!
    
//    MARK: - private propeties
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru-RU")
        return formatter
    }()
    
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

    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath)  {
        guard let picture: UIImage = UIImage(named: "\(indexPath.row)") else {
            return
        }
        cell.cellPicture.image = picture
        cell.cellPicture.contentMode = .scaleAspectFill
        cell.cellPicture.layer.cornerRadius = 16
        cell.cellPicture.clipsToBounds = true
        cell.backgroundColor = .ypBlack
        cell.dateLabel.text = dateFormatter.string(from: Date())
        if indexPath.row%2 == 0 {
            cell.likeButton.setImage(.likeActive, for: [])
        } else {
            cell.likeButton.setImage(.likeInactive, for: [])
        }
    }
}

//     MARK: - UITableViewDelegate extension

extension ImagesListViewController: UITableViewDelegate {
    
    // метод, вызываемый при выделении строки таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) // 1
        
        guard let imageListCell = cell as? ImagesListCell else { // 2
            print ("Ошибка инициализации кастомной ячейки")
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath) // 3
        return imageListCell // 4
    }
    
}

