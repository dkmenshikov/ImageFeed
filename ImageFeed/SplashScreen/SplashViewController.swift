//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 12.03.24.
//

import UIKit

final class SplashViewController: UIViewController, AuthViewControllerDelegate {
    
//    MARK: - Private properties
    
//    private let toAuthSegueID = "toAuthSegue"
//    private let toTabBarSegueID = "toTabBarSegue"
    
    private var logoImageView = UIImageView()
    
//    MARK: - Public methods
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.navigationController?.popViewController(animated: true)
        dismiss(animated: true)
        prepareProfileData()
    }
    
    func failedToLaodToken(_ vc: AuthViewController) {
        vc.navigationController?.popViewController(animated: true)
    }
    
//    MARK: - Lyfecycle
    
    override func viewDidLoad() {
        setViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let oAuthTokenStorage = OAuthTokenStorageService()
        if oAuthTokenStorage.authToken != nil {
            print("TOKEN: ", String(oAuthTokenStorage.authToken ?? ""))
            prepareProfileData()
        } else {
//            performSegue(withIdentifier: toAuthSegueID, sender: nil)
            switchToAuthViewController()
        }
    }
    
//    MARK: - Private methods
    
    private func prepareProfileData() {
        let profileService = ProfileService.shared
        profileService.fetchProfileData { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let profileData):
                print(profileData)
                fetchProfileImageURL(username: profileData.username)
                switchToTabBarController()
            case .failure(let error):
                print (error)
                switchToTabBarController()
            }
        }
    }
    
    private func switchToTabBarController() {
        let tabBarVC = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }
    
    private func switchToAuthViewController() {
//        let authVC = UIStoryboard(name: "Main", bundle: .main)
//            .instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
//        guard let authVC else { return }
//        authVC.delegate = self
//        authVC.modalPresentationStyle = .fullScreen
        let navController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController
        guard let navController else { return }
        navController.modalPresentationStyle = .fullScreen
        let viewController = navController.viewControllers[0] as? AuthViewController
//        present(authVC, animated: true)
        viewController?.delegate = self
        present(navController, animated: true)
    }
    
    private func fetchProfileImageURL(username: String) {
        let profileImageService = ProfileImageService.shared
        profileImageService.fetchProfileImageURL(username: username) { result in
            switch result {
            case .success(let profileURL):
                print("Profile URL:", profileURL)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SplashViewController {
    
//    MARK: - Views creation private methods
    
    private func setViews() {
        view.backgroundColor = .ypBlack
        logoImageView.image = UIImage.launchscreenPicture
        view.addSubview(logoImageView)
        setViewsConstraints()
    }
    
//    MARK: - Constraints setter
    
    private func setViewsConstraints() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
