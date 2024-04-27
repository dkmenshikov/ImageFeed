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
        guard let imagesListViewController = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImagesListViewController else { return }
        let imagesListPresenter = ImagesListPresenter()
        imagesListViewController.configure(presenter: imagesListPresenter)
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage.tabProfileActive,
            selectedImage: nil
        )
        let profilePresenter = ProfilePresenter()
        profileViewController.configure(presenter: profilePresenter)
        self.viewControllers = [imagesListViewController, profileViewController]
       }
    
}
