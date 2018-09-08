//
//  PreviewViewController.swift
//  videoDemo2
//
//  Created by xiaoqiang cao on 7/14/18.
//  Copyright © 2018 xiaoqiang cao. All rights reserved.
//


import UIKit
import Foundation

class PreviewViewController: UIViewController{
    var image: UIImage!
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photo.image = self.image
    }
    @IBAction func toClosePreview(_ sender: Any) {
    }
    @IBAction func toSavePhotoPreview(_ sender: Any) {
    }
}
