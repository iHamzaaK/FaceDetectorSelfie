//
//  PreviewViewController.swift
//  FaceDetectorSelfie
//
//  Created by Hamza Khan on 13/07/2019.
//  Copyright © 2019 Hamza Khan. All rights reserved.
//

import UIKit
import FaceCropper
class PreviewViewController: UIViewController {

    var image : UIImage!
    @IBOutlet var imgView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //unhides the navigation bar for  back button
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //displays cropped image from the FaceDetectorViewController
        self.imgView.image = image
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // since the camera needs to be full screen we hide navigation bar in the previous screen
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
