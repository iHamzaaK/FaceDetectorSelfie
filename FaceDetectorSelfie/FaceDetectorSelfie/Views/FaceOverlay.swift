//
//  FaceOverlay.swift
//  FaceDetectorSelfie
//
//  Created by Hamza Khan on 13/07/2019.
//  Copyright © 2019 Hamza Khan. All rights reserved.
//

import Foundation
import UIKit

class FaceOverlay: UIView {
    
    let screenBounds = UIScreen.main.bounds
    var overlayFrame: CGRect!
    var overlayBorderColor = UIColor.red.cgColor{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    internal init() {
        super.init(frame: screenBounds)
        backgroundColor = UIColor.clear
        overlayFrame = CGRect(x: (screenBounds.width - 300.0) / 2,
                              y: (screenBounds.height - 400.0) / 2,
                              width: 300.0,
                              height: 400.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        let overlayPath = UIBezierPath(rect: bounds)
        let ovalPath = UIBezierPath(ovalIn: overlayFrame)
        overlayPath.append(ovalPath)
        overlayPath.usesEvenOddFillRule = true
        // draw oval layer
        let ovalLayer = CAShapeLayer()
        ovalLayer.path = ovalPath.cgPath
        ovalLayer.fillColor = UIColor.clear.cgColor
        ovalLayer.strokeColor = overlayBorderColor
        ovalLayer.lineWidth = 5.0
        layer.addSublayer(ovalLayer)
    }
    
}
