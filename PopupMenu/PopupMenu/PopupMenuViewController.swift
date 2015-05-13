//
//  PopupMenuViewController.swift
//  PopupMenu
//
//  Created by Jiajun Zheng on 15/5/13.
//  Copyright (c) 2015年 hgProject. All rights reserved.
//

import UIKit

public extension UIViewController{
    
    func pm_presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        ///  转场动画代理
        let popoverAnimatorDelegate = PopoverAnimator()
        // 设置转场动画代理
        viewControllerToPresent.transitioningDelegate = popoverAnimatorDelegate
        // 设置 Modal 展现样式
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        presentViewController(viewControllerToPresent, animated: flag, completion: completion)
    }
}


class PopoverPresentationController: UIPresentationController {
    
    /// 遮罩视图
    lazy var dummingView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.2)
        
        let tap = UITapGestureRecognizer(target: self, action: "clickDummingView")
        v.addGestureRecognizer(tap)
        
        return v
        }()
    
    ///  点击遮罩视图
    func clickDummingView() {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override init(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
        
        // presentedViewController 是要 Modal 展现的视图控制器
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    ///  转场开始之前，插入遮罩视图
    override func presentationTransitionWillBegin() {
        dummingView.frame = containerView.bounds
        containerView.insertSubview(dummingView, atIndex: 0)
    }
    
    ///  容器视图将要布局子视图
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView().frame = CGRectMake(100, 56, 200, 300)
    }
    
}

class PopoverAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    /// 展现位置
    var presentedFrame: CGRect = CGRectZero
    // 是否展现标记
    var isPresenting = false
    
    // 由presentingViewController接管
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        // 返回自定义展现控制器
        return PopoverPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    ///  指定负责 `展现` 转场动画的对象
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        
        return self
    }
    
    ///  指定负责 `消失` 转场动画的对象
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        
        return self
    }
    
    ///  转场动画时间
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    ///  自定义转场动画
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresenting {
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
