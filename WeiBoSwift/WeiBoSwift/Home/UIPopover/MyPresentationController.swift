//
//  MyPresentationController.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/11.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

class MyPresentationController: UIPresentationController {

    var presentedFrame : CGRect = CGRect.zero
    private lazy var coverView : UIView = UIView()
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        presentedView?.frame = CGRect(x: 100, y: 55, width: 180, height: 250)
        
        setupCoverView()
    }
    
    
}

extension MyPresentationController{
    
    private func setupCoverView(){
    
        containerView?.insertSubview(coverView, at: 0)
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.bounds
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.coverViewClick))
        coverView.addGestureRecognizer(tapGes)
    }
}

extension MyPresentationController{
    
    @objc private func coverViewClick(){
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
