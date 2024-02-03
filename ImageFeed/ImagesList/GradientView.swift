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
  // 1
  @IBInspectable var startColor: UIColor = .gradientFrom
  @IBInspectable var endColor: UIColor = .gradientTo

  override func draw(_ rect: CGRect) {
    // 2
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    let colors = [startColor.cgColor, endColor.cgColor]
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let colorLocations: [CGFloat] = [0.0, 1.0]
    
    guard let gradient = CGGradient(
      colorsSpace: colorSpace,
      colors: colors as CFArray,
      locations: colorLocations
    ) else {
      return
    }
    
    let startPoint = CGPoint.zero
    let endPoint = CGPoint(x: 0, y: bounds.height)
    context.drawLinearGradient(
      gradient,
      start: startPoint,
      end: endPoint,
      options: []
    )
  }
}
