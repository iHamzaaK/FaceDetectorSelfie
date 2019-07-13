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

class Utility {
    static func getMainStoryboard() -> UIStoryboard{
        return UIStoryboard.init(name: Constants.mainStoryboardIdentifier, bundle: nil)
    }
    static func translateFaceBoundingBoxOnView(previewLayer: AVCaptureVideoPreviewLayer  , rect: CGRect)->CGRect{
        // 1
        let origin = previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.origin)
        
        // 2
        let size = previewLayer.layerPointConverted(fromCaptureDevicePoint: rect.size.cgPoint)
        
        // 3
        return CGRect(origin: origin, size: size.cgSize)
    }
    
    static func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)
        
        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x:cropRect.origin.x * (imageViewScale + 2),
                              y:cropRect.origin.y * imageViewScale/2,
                              width:cropRect.size.width * imageViewScale/3 ,
                              height:cropRect.size.height  * imageViewScale/3)
        
        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
            else {
                return nil
        }
        
        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
}
