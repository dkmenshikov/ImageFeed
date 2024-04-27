//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 3.03.24.
//

import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    
    //    MARK: - IBOutlets
    
    @IBOutlet weak var loginButton: UIButton!
    
    //    MARK: - Delegate properties
    
    weak var delegate: AuthViewControllerDelegate?
    
    //    MARK: - Sinletones shared instances
    
    private let o2AuthShared = OAuth2Service.shared
    
    //    MARK: - Private properties
    
    private let segueID = "ShowWebView"
    
    //    MARK: - Lyfecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        loginButton.accessibilityIdentifier = "Authenticate"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //    MARK: - Override methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueID {
            guard let webViewController = segue.destination as? WebViewViewController else {
                assertionFailure("Invalid segue destination")
                return
            }
            let authHelper = AuthHelper()
            let webViewPresenter = WebViewPresenter(authHelper: authHelper)
            webViewPresenter.view = webViewController
            webViewController.presenter = webViewPresenter
            webViewController.delegate = self
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //    MARK: - Private methods
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.backgroundColor = UIColor.ypWhite
        navigationController?.navigationBar.backIndicatorImage = UIImage.blackBackwardButton
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage.blackBackwardButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.ypBlack
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        o2AuthShared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            UIBlockingProgressHUD.show()
            switch result {
            case .success(let token):
                let oAuthTokenStorage = OAuthTokenStorageService()
                oAuthTokenStorage.authToken = token
                UIBlockingProgressHUD.dismiss()
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("[LOG]: \(error)")
                let alertPresenter = AlertPresenter(delegate: self)
                let alertData = AlertModel(
                    title: "Что-то пошло не так(",
                    text: "Не удалось войти в систему",
                    firstAction: .init(actionText: "Ок",
                                       actionCompletion: { [weak self] _ in
                                           guard let self else { return }
                                           alertPresenter.dismissAlert()
                                           delegate?.failedToLaodToken(self)
                                       }),
                    accessibilityIdentifier: "Alert"
                )
                alertPresenter.showAlert(alertData: alertData)
            }
        }
    }
}
