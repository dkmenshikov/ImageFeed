//
//  ViewController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 1.02.24.
//

import UIKit

class ImagesListViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        
        tableView.rowHeight = 270
        tableView.backgroundColor = .ypBlack
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }

    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)  {
        guard let picture: UIImage = UIImage(named: "\(indexPath.row)") else {
            return
        }
        
        cell.cellPicture.image = picture
        cell.cellPicture.contentMode = .scaleAspectFill
        cell.cellPicture.layer.cornerRadius = 16
        cell.cellPicture.clipsToBounds = true
        cell.backgroundColor = .ypBlack
 
        
    }

}

extension ImagesListViewController: UITableViewDelegate {
    
    // метод, вызываемый при выделении строки таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

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

