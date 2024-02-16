//
//  GradientView.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 3.02.24.
//

import Foundation
import UIKit

final class GradientView: UIView {
    
    override public class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.colors = [UIColor.gradientStart.cgColor, UIColor.gradientEnd.cgColor]
        backgroundColor = .clear
    }
    
}
