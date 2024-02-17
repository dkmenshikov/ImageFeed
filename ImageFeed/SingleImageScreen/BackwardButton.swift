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
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle("", for: [])
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -20, dy: -20).contains(point)

    }
    
}
