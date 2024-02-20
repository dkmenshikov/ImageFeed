//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 3.02.24.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier: String = "ImagesListCell"
    
    @IBOutlet private weak var cellPicture: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru-RU")
        return formatter
    }()
    
    func configCell(with indexPath: IndexPath)  {
        guard let picture: UIImage = UIImage(named: "\(indexPath.row)") else {
            return
        }
        cellPicture.image = picture
        cellPicture.contentMode = .scaleAspectFill
        cellPicture.layer.cornerRadius = 16
        cellPicture.clipsToBounds = true
        backgroundColor = .ypBlack
        dateLabel.text = dateFormatter.string(from: Date())
        if indexPath.row % 2 == 0 {
            likeButton.setImage(.likeActive, for: [])
        } else {
            likeButton.setImage(.likeInactive, for: [])
        }
    }
    
}
