//
//  EmotionPackage.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/27.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

class EmotionPackage: NSObject {

    var emotions : [Emotion] = [Emotion]()
    
    //根据path添加对应的package
    init(id : String) {
        super.init()
        
        //判断是recent
        if id == "" {
            
        }
    }
    
    
    /// 添加空表情
    ///
    /// - Parameter isRecent: 是否是最近
    fileprivate func addEmptyEmotion(isRecent : Bool) {
        
        let count = emotions.count % 21
        
        //防止是 recent == 0 的情况
        if count == 0 && !isRecent {
            return
        }
        
        for _ in count..<20 {
            emotions.append(Emotion(isEmpty: true))
        }
        
        emotions.append(Emotion(isRemove: true))
    }
}
