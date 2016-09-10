//
//  ViewController.swift
//  ScrollImageTest2
//
//  Created by DejingMa on 16/9/8.
//  Copyright © 2016年 DejingMa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }

    @IBAction func showLargeImage(sender: AnyObject) {
        let sb  = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("LargeImageVC") as! LargeImageVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

