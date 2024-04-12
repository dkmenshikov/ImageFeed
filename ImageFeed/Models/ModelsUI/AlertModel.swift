//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 11.04.24.
//

import UIKit

struct AlertModel {
    
    struct AlertAction {
        let actionText: String
        let actionCompletion: (UIAlertAction) -> Void
    }
    
    let title: String
    let text: String
    let firstAction: AlertAction
    let secondAction: AlertAction?
    let accessibilityIdentifier: String?
    
    init(title: String, text: String, firstAction: AlertAction, secondAction: AlertAction? = nil, accessibilityIdentifier: String? = nil) {
        self.title = title
        self.text = text
        self.firstAction = firstAction
        self.secondAction = secondAction
        self.accessibilityIdentifier = accessibilityIdentifier
    }
    
}
