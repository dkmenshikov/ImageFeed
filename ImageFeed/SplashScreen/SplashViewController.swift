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
}
