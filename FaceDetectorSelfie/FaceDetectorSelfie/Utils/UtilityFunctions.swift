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
    
    // crop face from the camera output
    static func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)
        
        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x:cropRect.origin.x * (imageViewScale ),
                              y:cropRect.origin.y * imageViewScale,
                              width:cropRect.size.width * imageViewScale ,
                              height:cropRect.size.height  * imageViewScale)
        
        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
            else {
                return nil
        }
        
        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
    
    static func imageCropping(imageToCrop : UIImage , toRect : CGRect) -> UIImage?{
        UIGraphicsBeginImageContext(toRect.size)
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.translateBy(x: 0.0, y: toRect.size.height)
        currentContext?.scaleBy(x: 1.0, y: -1.0)
        let clippedRect = CGRect(x: 0, y: 0, width: toRect.size.width, height: toRect.size.height)
        currentContext?.clip(to: clippedRect)
        let drawRect = CGRect(x: toRect.origin.x * -1, y: toRect.origin.y * -1, width: imageToCrop.size.width, height: imageToCrop.size.height)
        currentContext?.draw(imageToCrop.cgImage!, in: drawRect)
        currentContext?.scaleBy(x: 1.0, y: -1.0)
        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return croppedImage
        
    }
  
}
