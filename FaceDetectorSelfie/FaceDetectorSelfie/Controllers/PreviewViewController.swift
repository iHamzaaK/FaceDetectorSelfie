//
//  PreviewViewController.swift
//  FaceDetectorSelfie
//
//  Created by Hamza Khan on 13/07/2019.
//  Copyright © 2019 Hamza Khan. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    var image : UIImage!
    var cgImage : CGImage!
    @IBOutlet var imgView : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        imgView.image = image
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

}
