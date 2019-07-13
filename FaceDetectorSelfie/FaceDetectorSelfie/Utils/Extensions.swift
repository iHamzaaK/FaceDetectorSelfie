//
//  Extensions.swift
//  FaceDetectorSelfie
//
//  Created by Hamza Khan on 13/07/2019.
//  Copyright © 2019 Hamza Khan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        
        set {
            layer.cornerRadius = newValue
        }
    }
}

extension CGSize {
    var cgPoint: CGPoint {
        return CGPoint(x: width, y: height)
    }
}

extension CGPoint {
    var cgSize: CGSize {
        return CGSize(width: x, height: y)
    }
}


