//
//  PreviewVideoViewController.swift
//  videoDemo2
//
//  Created by xiaoqiang cao on 9/7/18.
//  Copyright © 2018 xiaoqiang cao. All rights reserved.
//

import UIKit

class PreviewVideoViewController: UIViewController {
   
    
    @IBAction func cancelVideo(_ sender: Any) {
        print("cancel video save and return")
    }
    @IBAction func saveVideo(_ sender: Any) {
        print("video saved and return")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
