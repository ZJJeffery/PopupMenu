//
//  ViewController.swift
//  PopupMenu
//
//  Created by Jiajun Zheng on 15/5/13.
//  Copyright (c) 2015年 hgProject. All rights reserved.
//

import UIKit

// base class which has a button for modal
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // test button shows how to use PoduoMenu
    @IBAction func showClick() {
        // create modalVc need for shown
        let modalVc = ModalViewController()
        
        // show it
        pm_presentViewController(modalVc, animated: true, completion:nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

     let popoverAnimatorDelegate = PopoverAnimator()
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let vc = segue.destinationViewController as! UIViewController
//        vc.transitioningDelegate = popoverAnimatorDelegate
//        
//        let w: CGFloat = 200
//        let x = (self.view.bounds.size.width - w) * 0.5
//        popoverAnimatorDelegate.presentedFrame =  CGRectMake(x, 56, w, 250)
//        
//        vc.modalPresentationStyle = UIModalPresentationStyle.Custom
//
//    }

}

// test class for modal test
class ModalViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.redColor()
    }
    
    
}

