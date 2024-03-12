//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 3.03.24.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
} 

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            guard let viewController = segue.destination as? WebViewViewController else {
                assertionFailure("Invalid segue destination")
                return
            }
            viewController.delegate = self
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private let segueID = "ShowWebView"
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage.blackBackwardButton
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.blackBackwardButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.ypBlack
    }
}
