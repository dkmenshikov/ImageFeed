//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 3.03.24.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
//    MARK: - Delegate properties
    
    weak var delegate: WebViewViewControllerDelegate?
    
//    MARK: - Private outlets
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    
//    MARK: - Private properties
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
//    MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthView()
        webView.navigationDelegate = self
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
            options: [],
            changeHandler: { [weak self] _, _ in
                guard let self else { return }
                self.updateProgress()
            })
    }

//    MARK: - Private methods
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1) <= 0.0001
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebConstants.unsplashAuthorizeURLString) else {
            assertionFailure("Invalid Auth URL")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: WebConstants.accessKey),
            URLQueryItem(name: "redirect_uri", value: WebConstants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: WebConstants.accessScope)
         ]
        guard let url = urlComponents.url else {
            assertionFailure("Invalid Query Items")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

//  MARK: - WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
