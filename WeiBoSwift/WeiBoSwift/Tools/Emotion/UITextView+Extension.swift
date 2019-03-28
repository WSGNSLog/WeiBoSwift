//
//  UITextView+Extension.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/27.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

///封装UITextView插入和读取属性字符串的方法
extension UITextView {
    
    
    /// 获取TextView的AttributeString
    ///
    /// - Returns: <#return value description#>
    func getAttributeString() -> String {
     
        //1.获取属性字符串
        let attrStr = NSMutableAttributedString(attributedString: attributedText)
        
        //2.遍历attrStr 对原有的表情进行替换
        let range = NSMakeRange(0, attrStr.length)
        attrStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            Mylog("\(String(describing: dict))" + "----" + "(\(range.location),\(range.length))")
            if let attachment = dict["NSAttachment"] as? EmotionAttachment{
                
                attrStr.replaceCharacters(in: range, with: attachment.chs!)
            }
            Mylog(attrStr.string)
        }
        
        return attrStr.string
    }
    
    func insertEmotionToTextView(emotion : Emotion) {
        Mylog(emotion)
        
        //空表情 不行
        if emotion.isEmpty {
            return
        }
        
        //删除表情
        if emotion.isRemove {
            deleteBackward()
            return
        }
        
        //emoji表情，直接插入
        if (emotion.emojiCode != nil) {
            /**
             let textRange = selectedTextRange!
             replace(textRange, withText: emotion.emojiCode!)
             */
            insertText(emotion.emojiCode!)
            return
        }
        
        //普通表情（图文混排）
        //1.设置attachMent
        let attachMent = EmotionAttachment()
        attachMent.chs = emotion.chs
        attachMent.image = UIImage(contentsOfFile: emotion.pngPath!)
        let font = self.font
        
        attachMent.bounds = CGRect(x: 0, y: -4, width: (font?.lineHeight)!, height: (font?.lineHeight)!)
        
        //2.通过attachMent生成待使用属性字符串
        let attrImageStr = NSAttributedString(attachment: attachMent)
        
        //3.取得原textView内容获得原属性字符串
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        //4.替换当前位置的属性字符串并重新赋值给textView
        let range = selectedRange
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        
        attributedText = attrMStr
        
        //5.处理出现的遗留问题
        self.font = font
        selectedRange = NSMakeRange(range.location + 1, range.length)
    }
}
