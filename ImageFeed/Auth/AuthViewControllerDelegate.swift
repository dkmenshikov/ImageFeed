//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 13.03.24.
//

import UIKit

protocol AuthViewControllerDelegate: UIViewController {
    func didAuthenticate(_ vc: AuthViewController)
    func failedToLaodToken(_ vc: AuthViewController)
}
