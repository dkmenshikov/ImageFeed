//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 3.03.24.
//

import UIKit

final class AuthViewController: UIViewController, WebViewViewControllerDelegate {

//    MARK: - Delegate properties
    
    var delegate: AuthViewControllerDelegate?
    
//    MARK: - Sinletones shared instances
    
    private let o2AuthShared = OAuth2Service.shared
    
//    MARK: - Private properties
    
    private let segueID = "ShowWebView"
    
//    MARK: - Public methods
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        o2AuthShared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let token):
                let oAuthTokenStorage = OAuthTokenStorageService()
                oAuthTokenStorage.authToken = token
                print(token)
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print (error)
            }
        }
    }
    
//    MARK: - Lyfecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
//    MARK: - Override methods
    
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
    
//    MARK: - Private methods
    
    private func configureBackButton() {
        navigationController?.navigationBar.backgroundColor = UIColor.ypWhite
        navigationController?.navigationBar.backIndicatorImage = UIImage.blackBackwardButton
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.blackBackwardButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.ypBlack
    }
}
