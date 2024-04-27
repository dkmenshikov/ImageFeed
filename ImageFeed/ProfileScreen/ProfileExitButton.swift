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
        setImage(.profileExitButton, for: [])
        accessibilityIdentifier = "logoutButton"
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle("", for: [])
        setImage(.profileExitButton, for: [])
        accessibilityIdentifier = "logoutButton"
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return bounds.insetBy(dx: -12, dy: -10).contains(point)
    }
    
}
