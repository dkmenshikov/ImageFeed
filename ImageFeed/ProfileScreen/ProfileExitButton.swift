//
//  ProfileExitButton.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 16.02.24.
//

import Foundation
import UIKit

final class ProfileExitButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 20, height: 24))
        setTitle("", for: [])
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle("", for: [])
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -24, dy: -20).contains(point)

    }
    
}
