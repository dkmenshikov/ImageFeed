//
//  GradientView.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 3.02.24.
//

import Foundation
import UIKit

@IBDesignable
class GradientView: UIView {
    
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.gradientStart.cgColor, UIColor.gradientEnd.cgColor]
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.gradientStart.cgColor, UIColor.gradientEnd.cgColor]
        backgroundColor = .clear
    }
    
    
}
