//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 3.02.24.
//

import Foundation
import Kingfisher
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
    
    func configCell(with indexPath: IndexPath, photo: Photo)  {
        cellPicture.contentMode = .scaleAspectFill
        cellPicture.kf.indicatorType = .activity
        cellPicture.kf.setImage(with: photo.thumbImageURL,
                                placeholder: UIImage.photoThumbStub)
        cellPicture.layer.cornerRadius = 16
        cellPicture.clipsToBounds = true
        backgroundColor = .ypBlack
        dateLabel.text = dateFormatter.string(from: photo.createdAt ?? Date())
        likeButton.setImage(photo.isLiked ? .likeActive : .likeInactive, for: [])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellPicture.kf.cancelDownloadTask()
    }
    
}
