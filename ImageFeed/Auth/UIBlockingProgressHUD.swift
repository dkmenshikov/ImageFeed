//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 19.03.24.
//

import ProgressHUD
import UIKit

final class UIBlockingProgressHUD {
    
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show() {
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate(nil, .circleArcDotSpin)
    }
    
    static func dismiss() {
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
    
}
