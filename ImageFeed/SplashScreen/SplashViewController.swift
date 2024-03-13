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
        performSegue(withIdentifier: toTabBarSegueID, sender: nil)
    }
    
//    MARK: - Lyfecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let oAuthTokenStorage = OAuthTokenStorageService()
        if oAuthTokenStorage.authToken != nil {
            performSegue(withIdentifier: toTabBarSegueID, sender: nil)
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
}
