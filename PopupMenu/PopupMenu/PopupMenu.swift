//
//  PopupMenu.swift
//  PopupMenu
//
//  Created by Jiajun Zheng on 15/5/14.
//  Copyright (c) 2015年 hgProject. All rights reserved.
//

import UIKit

///  转场动画代理
var popoverAnimatorDelegate : PopoverAnimator?
//MARK: - UIViewController的分类，提供了转场动画的自定义方法
extension UIViewController {
    /**
    自定义modal的跳转方式
    
    :param: viewControllerToPresent 需要展示的viewController
    :param: showFrame               展示视图在屏幕的frame
    :param: animationAppearBlock    展示动画代码（返回的时间是转场动画上下文关闭的时间）
    :param: animationDisappearBlock 消失动画代码（返回的时间是转场动画上下文关闭的时间）
    关于转场动画上下文时长说明：
        转场动画上下文关闭的时间决定了改转场动画封锁界面的用户交互能力的时长，如果返回0表示立马接受用户交互，
    那么可能存在在动画过程中用户交互而导致动画达不到预期效果。
        一般建议返回动画的时间长度，正好动画结束，然后开启用户交互能力。
        特殊需求可以填写特殊时长
    
    :param: completion              完成跳转的回调代码
    */
    func pm_presentViewController(#viewControllerToPresent: UIViewController,
                                    showFrame : CGRect,
                                    animationAppearBlock:(view: UIView)->(NSTimeInterval),
                                    animationDisappearBlock:(view: UIView)->(NSTimeInterval),
                                    completion: (() -> Void)?) {
        
        popoverAnimatorDelegate = PopoverAnimator()
        // 设置转场动画代理
        viewControllerToPresent.transitioningDelegate = popoverAnimatorDelegate
        // 设置 Modal 展现样式
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationStyle.Custom
        // 设置需要展现的大小
        popoverAnimatorDelegate!.presentedFrame =  showFrame
        // 设置开场动画的block
        popoverAnimatorDelegate!.animationAppearBlock = animationAppearBlock
        // 设置了下场动画的block
        popoverAnimatorDelegate!.animationDisappearBlock = animationDisappearBlock
        // 开始 跳转
        presentViewController(viewControllerToPresent, animated: true, completion: completion)
    }
}


//MARK: - 以下为工具类和方法
//MARK: - 转场动画代理
class PopoverAnimator: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    /// 是否展现标记
    var isPresented = false
    /// 展现位置
    var presentedFrame: CGRect = CGRectZero
    /// 动画代码
    /// 出现动画，给预先留好的view设置动画，在需要的时候调用该block传递需要做动画的视图即可产生动画
    var animationAppearBlock:((view: UIView)->(NSTimeInterval))?
    /// 消失代码，给预先留好的view设置动画，在需要的时候调用该block传递需要做动画的视图即可产生动画
    var animationDisappearBlock:((view: UIView)->(NSTimeInterval))?
    
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
        return 0
    }
    
    /**
    transitionContext 中定义了专场相关属性
    
    一旦实现了此方法，所有动画相关的动作都交由程序员处理
    */
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if isPresented {
            // 开场动画
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            transitionContext.containerView().addSubview(toView)
            // 根据给的动画时长来结束动画
            let time = animationAppearBlock!(view: toView) as Double
            let time_t = dispatch_time(DISPATCH_TIME_NOW, (Int64)(time * (Double)(NSEC_PER_SEC)))
            dispatch_after(time_t, dispatch_get_main_queue(), { () -> Void in
                transitionContext.completeTransition(true)
            })
        } else {
            // 消失动画
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            // 根据动画时长来结束动画
            let time = animationDisappearBlock!(view: fromView) as Double
            let time_t = dispatch_time(DISPATCH_TIME_NOW, (Int64)(time * (Double)(NSEC_PER_SEC)))
            dispatch_after(time_t, dispatch_get_main_queue(), { () -> Void in
                transitionContext.completeTransition(true)
                fromView.removeFromSuperview()
            })
        }
    }
}



//MARK: - 转场动画展现控制器
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

