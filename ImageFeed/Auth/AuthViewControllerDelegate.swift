//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 13.03.24.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
