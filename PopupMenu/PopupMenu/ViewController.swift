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
        // 显示的控制器的frame
        let w: CGFloat = 200
        let x = (self.view.bounds.size.width - w) * 0.5
        let frame =  CGRectMake(x, 56, w, 250)
        // show it
        
        pm_presentViewController(modalVc, showFrame: frame, animationAppearBlock: { (view, transitionContext) -> (NSTimeInterval) in
            // 动画内容
            view.transform = CGAffineTransformMakeScale(1.0, 0)
            view.layer.anchorPoint = CGPointMake(0.5, 0)
            
            UIView.animateWithDuration(3,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 5.0,
                options: nil,
                animations: {
                    println(view.layer.presentationLayer())
                    view.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }, completion: { (_) in
                    //                    view.transform = CGAffineTransformIdentity
                    println(view.layer.animationKeys())
                    println(view.layer.presentationLayer().center)
//                    ////                    // 不应该让用于调用
//                    transitionContext.completeTransition(true)
            })
            return 3.0
        }, animationDisappearBlock: { (_, _) -> (NSTimeInterval) in
            return 0.0
        }, completion: nil)
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
    deinit{
        println("我去了")
    }
    
}

