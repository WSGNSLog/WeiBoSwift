//
//  MainTabBarController.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/5.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    fileprivate lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    override func viewDidLoad() {
        super.viewDidLoad()


        setupComposeBtn()
    
    }
    
    
        /*
        addChild(HomeController(), title: "首页", imageName: "tabbar_home")
        addChild(MessageController(), title: "消息", imageName: "tabbar_message_center")
        addChild(DiscorverController(), title: "发现", imageName: "tabbar_discover")
        addChild(ProfileController(), title: "我", imageName: "tabbar_profile")
 
    private func addChild(_ childVC: UIViewController, title : String, imageName: String) {
        tabBar.tintColor = UIColor.orange
        
        childVC.view.backgroundColor = UIColor.yellow
        childVC.title = title
        childVC.tabBarItem.image = UIImage(named: imageName)
        childVC.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
        let childNav = UINavigationController(rootViewController: childVC)
        
        addChild(childNav)
    }
*/
    
}
extension MainTabBarController{
    fileprivate func setupComposeBtn(){
        tabBar.addSubview(composeBtn)
        
        
        composeBtn.center = CGPoint(x: tabBar.center.x, y: tabBar.bounds.size.height*0.5)
        
        composeBtn.addTarget(self, action: #selector(MainTabBarController.composeBtnClick), for: .touchUpInside)
    }
    
    /// 调整tabbar中的item
//    private func setupTabbarItems() {
//        // 1.遍历所有的item
//        for i in 0..<tabBar.items!.count {
//            // 2.获取item
//            let item = tabBar.items![i]
//
//            // 3.如果是下标值为2,则该item不可以和用户交互
//            if i == 2 {
//                item.isEnabled = false
//                continue
//            }
    
            // 设置其他item的选中时候的图片
//            item.selectedImage = UIImage(named: imageNames[i] + "_highlighted")
//        }
//    }
    
}

extension MainTabBarController{
    
    @objc fileprivate func composeBtnClick(){
    
        print("composeBtnClick")
    }
}
