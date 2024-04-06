//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 6.04.24.
//

import Foundation

protocol ImagesListCellDelegate {
    func changeLike(indexPath: IndexPath, completion: @escaping (Bool) -> (Void))
}
