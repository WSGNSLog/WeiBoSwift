//
//  UIButton-Extension.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/9.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

extension UIButton
{
    //类方法
    class func creatButton () -> UIButton {
        return UIButton()
    }
    convenience init (imageName : String, bgImageName : String) {
        self.init()
        setBackgroundImage(UIImage(named: bgImageName), for: .normal)
        setBackgroundImage(UIImage(named: bgImageName + "_highlighted"), for: .highlighted)
        setImage(UIImage(named: imageName), for: .normal)
        setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        sizeToFit()
        
    }
    
    convenience init(bgColor : UIColor, fontSize : CGFloat, title : String) {
        self.init()
        
        backgroundColor = bgColor
        titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        setTitle(title, for: .normal)
    }
}



