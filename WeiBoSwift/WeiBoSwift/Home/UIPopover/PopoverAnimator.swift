//
//  PopoverAnimator.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/12.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

class PopoverAnimator: NSObject {

    //判断是不是弹出动画
    fileprivate var isPresent : Bool = false
    
    //viewc消失之后的穿出的闭包
    var callBack : ((_ dismissFinsished : Bool) -> ())?
    
    init(dismissFinsished : @escaping ((_ : Bool) -> ())) {
        self.callBack = dismissFinsished
    }
    
}

extension PopoverAnimator : UIViewControllerTransitioningDelegate{
    // 得到presentController，可以修改对应的弹出view 的frame
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        // 这里需要自定义UIPresentationController
        let presentVC = MyPresentationController(presentedViewController: presented, presenting: presenting)
        presentVC.presentedFrame = CGRect(x: 100, y: 60, width: 180, height: 250) // 设置给定的frame
        return presentVC
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresent = false
        self.callBack!(isPresent)
        return self
    }
}

extension PopoverAnimator : UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresent ? animateForPresent(transitionContext: transitionContext): animateForDismiss(transitionContext: transitionContext)
    }
    
    func animateForPresent(transitionContext : UIViewControllerContextTransitioning) {
        let presentView = transitionContext.view(forKey: .to)
        transitionContext.containerView.addSubview(presentView!)
        
        presentView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        presentView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            presentView?.transform = CGAffineTransform.identity
        },completion: {(_) -> Void in
            transitionContext.completeTransition(true)
        })
        
    }

    /// 自定义弹出动画
    func animateForDismiss(transitionContext: UIViewControllerContextTransitioning) {
        
        // 得到要去的view
        let presentView = transitionContext.view(forKey: .from)
        
        // 添加到Model的ContainerView中去
        transitionContext.containerView.addSubview(presentView!)
        
        // 执行对应动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            
            presentView?.transform = CGAffineTransform(scaleX: 1.0, y: 0.0001)
            
        }, completion: { (_) -> Void in
            
            // 移除View并告诉上下文已经完成动画
            presentView?.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}
