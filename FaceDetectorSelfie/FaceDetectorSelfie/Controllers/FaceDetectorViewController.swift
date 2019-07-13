//
//  FaceDetectorViewController.swift
//  FaceDetectorSelfie
//
//  Created by Hamza Khan on 13/07/2019.
//  Copyright © 2019 Hamza Khan. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class FaceDetectorViewController: UIViewController {

    var previewLayer : AVCaptureVideoPreviewLayer!
    var captureDevice : AVCaptureDevice!
    let captureSession = AVCaptureSession()
    let faceOverlay = FaceOverlay()
    var faceBoundBox : CGRect!
    var isFaceInOverlay = false{
        didSet{
            setupSnapView()
        }
    }
    var didTapOnTakePicture = false
    
    @IBOutlet var btnSnap : UIButton!
    @IBOutlet var viewSnapBtn : UIView!
    let queue = DispatchQueue(
        label: Constants.dataOutputQueue,
        qos: .userInitiated,
        attributes: [],
        autoreleaseFrequency: .workItem)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(faceOverlay)
        isFaceInOverlay = false
        setupCamera()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        captureSession.startRunning()
    }

}

extension FaceDetectorViewController{
    func setupSnapView(){
        DispatchQueue.main.async {
            self.viewSnapBtn.isHidden = !self.isFaceInOverlay
            if self.isFaceInOverlay{
                self.view.bringSubviewToFront(self.viewSnapBtn)
            }
        }
    }
    
    func sendImageToPreviewViewController(image: UIImage){
        DispatchQueue.main.async {
            self.didTapOnTakePicture = false
            self.captureSession.stopRunning()
            let destinationVC = Utility.getMainStoryboard().instantiateViewController(withIdentifier: Constants.previewVCIdentifier) as! PreviewViewCbontroller
            destinationVC.image = Utility.cropImage(image, toRect: self.faceOverlay.overlayFrame, viewWidth: self.previewLayer.frame.size.width, viewHeight:  self.previewLayer.frame.size.width)!
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
    @IBAction func didTapOnSnap(){
        didTapOnTakePicture = true
    }
    
    func vnFaceDetectionRequest(cgImage: CGImage){
        
        let request = VNDetectFaceRectanglesRequest.init { (req, err) in
            if let err = err{
                print(Constants.faceDetectionError + ":", err)
                return
            }
            if req.results?.count  ?? 0 < 1{
                self.isFaceInOverlay = false
            }
            else{
                req.results?.forEach({ (res) in
                    guard let faceObservation = res as? VNFaceObservation   else { return }
                    DispatchQueue.main.async {
                        self.faceBoundBox =  Utility.translateFaceBoundingBoxOnView(previewLayer: self.previewLayer ,rect: faceObservation.boundingBox)
                        if self.faceOverlay.overlayFrame.contains(self.faceBoundBox){
                            self.isFaceInOverlay = true
                        }
                        else{
                            self.isFaceInOverlay = false
                        }
                    }
                })
            }
        }
        let handler = VNImageRequestHandler.init(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        }
        catch{
            self.isFaceInOverlay = false
        }
    }
}

extension FaceDetectorViewController{
    func setupCamera(){
        captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .front) else {
                                                    fatalError(Constants.frontCameraError)
        }
        captureDevice = camera
        beginSession()
    }
    
    func setupPreviewLayer(){
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.previewLayer.frame = self.view.frame
        self.view.layer.insertSublayer(self.previewLayer!, at: 0)
        
    }
    func beginSession(){
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        }catch{
            print(error.localizedDescription)
        }
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: queue)
        dataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString):NSNumber(value:kCVPixelFormatType_32BGRA)] as [String : Any]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        if captureSession.canAddOutput(dataOutput){
            captureSession.addOutput(dataOutput)
        }
        captureSession.commitConfiguration()
        self.setupPreviewLayer()
    }
}


extension FaceDetectorViewController : AVCaptureVideoDataOutputSampleBufferDelegate{
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        print("Hello")
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let cameraImage = CIImage(cvPixelBuffer: pixelBuffer!).oriented(.right).transformed(by: CGAffineTransform(scaleX: -1, y: 1))
        let context:CIContext = CIContext.init(options: nil)
        guard let cgImage:CGImage = context.createCGImage(cameraImage, from: cameraImage.extent) else { return }
        let uiImage = UIImage(cgImage: cgImage)
        if didTapOnTakePicture{
            sendImageToPreviewViewController(image: uiImage)
        }
        else{
            vnFaceDetectionRequest(cgImage: cgImage)
        }
    }
}
