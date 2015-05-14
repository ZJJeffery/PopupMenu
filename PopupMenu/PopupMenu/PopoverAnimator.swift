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
//    /// 动画代码
    ///  出现代码
    var animationAppearBlock:((view: UIView, transitionContext: UIViewControllerContextTransitioning)->(NSTimeInterval))?
    /// 消失代码
    var animationDisappearBlock:((view: UIView,transitionContext: UIViewControllerContextTransitioning)->(NSTimeInterval))?
    
    var animationEndBlock:(()->())?
    
    var finalFrame: CGRect?
    
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
            // 根据用户给的动画时长来结束动画
            let time = animationAppearBlock!(view: toView,transitionContext: transitionContext) - 1.0 as Double
            let time_t = dispatch_time(DISPATCH_TIME_NOW, (Int64)(time * (Double)(NSEC_PER_SEC)))
            println(time)
            dispatch_after(time_t, dispatch_get_main_queue(), { () -> Void in
                transitionContext.completeTransition(true)
            })
        } else {
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            // 根据动画时长来结束动画
            let time = animationDisappearBlock!(view: fromView,transitionContext: transitionContext) as Double
            let time_t = dispatch_time(DISPATCH_TIME_NOW, (Int64)(time * (Double)(NSEC_PER_SEC)))
            dispatch_after(time_t, dispatch_get_main_queue(), { () -> Void in
                transitionContext.completeTransition(true)
                fromView.removeFromSuperview()
            })

        }
    }
    // 过场动画结束的时候调用
    func animationEnded(transitionCompleted: Bool) {
        println("\(__FUNCTION__)")
//         animationEndBlock!()
    }

    

}
