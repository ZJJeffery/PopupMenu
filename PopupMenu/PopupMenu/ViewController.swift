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
        
        // 进行跳转，携带跳转动画代码进行跳转
        pm_presentViewController(
        viewControllerToPresent:modalVc,
        showFrame: frame,
        animationAppearBlock:{(view) -> (NSTimeInterval) in
            /* 开场动画内容 ***************  开场动画内容     */
            // 属性准备
            view.transform = CGAffineTransformMakeScale(1.0, 0)
            view.layer.anchorPoint = CGPointMake(0.5, 0)
            let animationDuration = 0.5
            // 动画代码，动画属性
            UIView.animateWithDuration(animationDuration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 2.0,
                options: nil,
                animations: {
                    // 动画最终属性
                    view.transform = CGAffineTransformMakeScale(1.0, 1.0)
                    
                }, completion: { (_) in
                    //无完成动画
            })
            // 返回动画时长，也可以小于该时长用于提早开启用户交互
            return animationDuration
        },
        animationDisappearBlock: { (_) -> (NSTimeInterval) in
            /* 消失动画内容 ***************  消失动画内容     */
            // 无消失动画
            return 0.0
        },
        completion: nil)
    }
}

// 测试类
class ModalViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
    }
    deinit{
        // 测试是否释放
        println("我去了")
    }
    
}

