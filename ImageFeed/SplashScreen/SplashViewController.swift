//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 12.03.24.
//

import UIKit

final class SplashViewController: UIViewController, AuthViewControllerDelegate {
    
//    MARK: - Private properties
    
    private let toAuthSegueID = "toAuthSegue"
    private let toTabBarSegueID = "toTabBarSegue"
    
//    MARK: - Public methods
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.navigationController?.popViewController(animated: true)
        dismiss(animated: true)
        prepareProfileData()
    }
    
//    MARK: - Lyfecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let oAuthTokenStorage = OAuthTokenStorageService()
        if oAuthTokenStorage.authToken != nil {
            prepareProfileData()
        } else {
            performSegue(withIdentifier: toAuthSegueID, sender: nil)
        }
    }
    
//    MARK: - Override methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toAuthSegueID {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(toAuthSegueID)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
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
                performSegue(withIdentifier: toTabBarSegueID, sender: nil)
            case .failure(let error):
                print (error)
                performSegue(withIdentifier: toTabBarSegueID, sender: nil)
            }
        }
    }
}
