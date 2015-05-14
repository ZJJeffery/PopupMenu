//
//  PopupMenu.swift
//  PopupMenu
//
//  Created by Jiajun Zheng on 15/5/14.
//  Copyright (c) 2015年 hgProject. All rights reserved.
//

import UIKit

///  转场动画代理
let popoverAnimatorDelegate = PopoverAnimator()

extension UIViewController {

    func pm_presentViewController(viewControllerToPresent: UIViewController, showFrame : CGRect, completion: (() -> Void)?) {
        // 设置转场动画代理
        viewControllerToPresent.transitioningDelegate = popoverAnimatorDelegate
        // 设置 Modal 展现样式
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationStyle.Custom

        popoverAnimatorDelegate.presentedFrame =  showFrame
        
        presentViewController(viewControllerToPresent, animated: true, completion: completion)
    }
}
