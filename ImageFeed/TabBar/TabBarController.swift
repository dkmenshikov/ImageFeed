//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 29.03.24.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)       
        let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        )
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage.tabProfileActive,
            selectedImage: nil
        )
       self.viewControllers = [imagesListViewController, profileViewController]
       }
    
}
