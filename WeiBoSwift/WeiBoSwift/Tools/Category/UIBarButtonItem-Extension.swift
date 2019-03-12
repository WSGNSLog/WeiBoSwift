//
//  UIBarButtonItem-Extension.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/10.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    convenience init(imageName : String) {
        
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), for: .highlighted)
        btn.sizeToFit()
        
        self.init(customView: btn)
    }
}
