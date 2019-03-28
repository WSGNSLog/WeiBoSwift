//
//  EmotionManager.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/27.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

class EmotionManager: NSObject {

    var packages : [EmotionPackage] = [EmotionPackage]()
    
    //MARK : 重写init方法
    override init() {
        //recnet
        packages.append(EmotionPackage(id: ""))
        
        //default
        packages.append(EmotionPackage(id: "com.sina.default"))
        
        //emoji
        packages.append(EmotionPackage(id: "com.apple.emoji"))
        
        //lxh
        packages.append(EmotionPackage(id: "com.sina.lxh"))
    }
    
}
