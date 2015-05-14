//
//  PopoverPresentationController.swift
//  PopupMenu
//
//  Created by Jiajun Zheng on 15/5/14.
//  Copyright (c) 2015年 hgProject. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
    /// 展现位置
    var presentedFrame: CGRect = CGRectZero
    
    /// 遮罩视图
    lazy var dummingView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clearColor()
        
        let tap = UITapGestureRecognizer(target: self, action: "clickDummingView")
        v.addGestureRecognizer(tap)
        
        return v
        }()
    
    ///  点击遮罩视图
    func clickDummingView() {
        // 关闭视图控制器
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override init(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
        // presentedViewController 是要 Modal 展现的视图控制器
        println(presentedViewController)
        
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    ///  容器视图将要调整大小
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        dummingView.frame = containerView.bounds
        containerView.insertSubview(dummingView, atIndex: 0)
        
        presentedView().frame = presentedFrame
    }

}
