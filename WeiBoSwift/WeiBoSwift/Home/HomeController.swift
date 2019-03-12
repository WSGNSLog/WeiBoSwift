//
//  HomeController.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/5.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

class HomeController: BaseController {

    private lazy var titleBtn : TitleButton = TitleButton()
    
    fileprivate lazy var popoverAnimator :PopoverAnimator = PopoverAnimator{[unowned self](dismissFinished) in
        self.titleBtn.isSelected = dismissFinished
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        visitorView.addRotateionAnimation()
        if !isLogin {
            //return
        }
        
        setupNavigationBar()
    }

   
}
extension HomeController{
    private func setupNavigationBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention")
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop")
        
        titleBtn.setTitle("weibo", for: .normal)
        titleBtn.addTarget(self, action: #selector(self.titleBtnClick(titleBtn:)), for: .touchUpInside)
        navigationItem.titleView = titleBtn
    }
}

extension HomeController{
    @objc private func titleBtnClick(titleBtn : TitleButton){
        titleBtn.isSelected = !titleBtn.isSelected
        let popoverVC = PopoverController()
        popoverVC.modalPresentationStyle = .custom
        
        popoverVC.transitioningDelegate = popoverAnimator
        
        present(popoverVC, animated: true, completion: nil)
    }
}
extension HomeController : UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        return MyPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
