//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 3.03.24.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
}
