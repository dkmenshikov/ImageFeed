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
    private weak var delegate: ImagesListCellDelegate?
    private var indexPath: IndexPath?
    
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
    
    func configCell(with indexPath: IndexPath, photo: Photo, delegate: ImagesListCellDelegate)  {
        likeButton.accessibilityIdentifier = "likeButton"
        cellPicture.contentMode = .scaleAspectFill
        cellPicture.kf.indicatorType = .activity
        cellPicture.kf.setImage(with: photo.thumbImageURL,
                                placeholder: UIImage.photoThumbStub)
        cellPicture.layer.cornerRadius = 16
        cellPicture.clipsToBounds = true
        backgroundColor = .ypBlack
        if let date = photo.createdAt {
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = ""
        }
        likeButton.setImage(photo.isLiked ? .likeActive : .likeInactive, for: [])
        self.delegate = delegate
        self.indexPath = indexPath
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellPicture.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonDidTap(_ sender: Any) {
        guard let indexPath else { return }
        delegate?.changeLike(indexPath: indexPath) { [weak self] result in
            guard let self else { return }
            if result {
                self.likeButton.setImage(self.likeButton.image(for: []) == .likeInactive ? .likeActive : .likeInactive, for: [])
            }
        }
    }
}
