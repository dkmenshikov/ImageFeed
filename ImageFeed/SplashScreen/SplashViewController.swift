//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 12.03.24.
//

import UIKit

final class SplashViewController: UIViewController, AuthViewControllerDelegate {
    
    private let toAuthSegueID = "toAuthSegue"
    private let toTabBarSegueID = "toTabBarSegue"
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        performSegue(withIdentifier: toTabBarSegueID, sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let oAuthTokenStorage = OAuthTokenStorageService()
        if let token = oAuthTokenStorage.authToken {
            print("FOUND TOKEN \(token)")
            performSegue(withIdentifier: toTabBarSegueID, sender: nil)
        } else {
            print("TOKEN HASN'T BEEN FOUND")
            performSegue(withIdentifier: toAuthSegueID, sender: nil)
        }
    }
    
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
