//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 11.04.24.
//

import UIKit

final class AlertPresenter {
    
    weak var delegate: UIViewController?
    
    private var alert: UIAlertController
    
    init(delegate: UIViewController?) {
        self.delegate = delegate
        self.alert = .init(title: "", message: "", preferredStyle: .alert)
    }
    
    func showAlert(alertData: AlertModel) {
        alert = UIAlertController(title: alertData.title,
                                      message: alertData.text,
                                      preferredStyle: .alert)
        if let accessibilityIdentifier = alertData.accessibilityIdentifier {
            alert.view.accessibilityIdentifier = accessibilityIdentifier
        }
        let firstAction = UIAlertAction(title: alertData.firstAction.actionText, style: .default, handler: alertData.firstAction.actionCompletion
        )
        alert.addAction(firstAction)
        if let secondActionData = alertData.secondAction {
            let secondAction = UIAlertAction(title: secondActionData.actionText, style: .default, handler: secondActionData.actionCompletion)
            alert.addAction(secondAction)
        }
        delegate?.present(alert, animated: true, completion: nil)
    }
    
    func dismissAlert() {
        alert.dismiss(animated: true)
    }
}
