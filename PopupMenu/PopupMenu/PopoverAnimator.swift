//
//  PopoverAnimator.swift
//  PopupMenu
//
//  Created by Jiajun Zheng on 15/5/14.
//  Copyright (c) 2015年 hgProject. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    /// 是否展现标记
    var isPresented = false
    /// 展现位置
    var presentedFrame: CGRect = CGRectZero
    
    // MARK: - UIViewControllerTransitioningDelegate
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        let pop = PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
        pop.presentedFrame = presentedFrame
        
        return pop
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        return self
    }
    
    // MARK: - UIViewControllerAnimatedTransitioning
    // 转场动画时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.25
    }
    
    /**
    transitionContext 中定义了专场相关属性
    
    一旦实现了此方法，所有动画相关的动作都交由程序员处理
    */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresented {
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            transitionContext.containerView().addSubview(toView)
            toView.transform = CGAffineTransformMakeScale(1.0, 0)
            toView.layer.anchorPoint = CGPointMake(0.5, 0)
            
            UIView.animateWithDuration(transitionDuration(transitionContext),
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 5.0,
                options: nil,
                animations: {
                    toView.transform = CGAffineTransformMakeScale(1.0, 1.0)
                }, completion: { (_) in
                    toView.transform = CGAffineTransformIdentity
                    transitionContext.completeTransition(true)
            })
        } else {
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
