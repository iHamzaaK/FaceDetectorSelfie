//
//  UtilityFunctions.swift
//  FaceDetectorSelfie
//
//  Created by Hamza Khan on 13/07/2019.
//  Copyright © 2019 Hamza Khan. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import CoreGraphics
class Utility {
    static func getMainStoryboard() -> UIStoryboard{
        return UIStoryboard.init(name: Constants.mainStoryboardIdentifier, bundle: nil)
    }
    //converts face bounding box dimensions. face bounding box gives coordinates percent which needs to be converted with view coordinates
    static func translateFaceBoundingBoxOnView(previewLayer: AVCaptureVideoPreviewLayer  , rect: CGRect)->CGRect{
        // 1
        let origin = previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.origin)
        
        // 2
        let size = previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.size.cgPoint)
        
        // 3
        return CGRect(origin: origin, size: size.cgSize)
    }
    
   
  
}
