//
//  BackwardButton.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 17.02.24.
//

import Foundation
import UIKit

final class BackwardButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        setTitle("", for: [])
        accessibilityIdentifier = "backwardButton"
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle("", for: [])
        accessibilityIdentifier = "backwardButton"
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -10, dy: -10).contains(point)

    }
    
}
