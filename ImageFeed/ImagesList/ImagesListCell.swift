//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 3.02.24.
//

import Foundation
import UIKit

//@IBDesignable
final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier: String = "ImagesListCell"
    
//    @IBInspectable
//    var picture: UIImage = UIImage(named: "0") ?? UIImage()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setAppearance()
    }
    
    func setAppearance () {
        layer.cornerRadius = 16
        clipsToBounds = true
        
//        let pictureImageView: UIImageView = UIImageView(image: picture)
//        
//        addSubview(pictureImageView)
//        contentMode = .scaleAspectFill
        
        
    }
    
}
