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
    
    @IBOutlet 
    var cellPicture: UIImageView!
    
    @IBOutlet 
    var likeButton: UIButton!
    
    @IBOutlet 
    var dateLabel: UILabel!
    
}
