//
//  EmotionViewCell.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/27.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

class EmotionViewCell: UICollectionViewCell {
    
    fileprivate lazy var emotionBtn : UIButton = UIButton()
    
    //属性模型
    var emotion : Emotion? {
        didSet{
            guard let emotion = emotion else {
                return
            }
            
            emotionBtn.setImage(UIImage(contentsOfFile: emotion.pngPath ?? ""), for: .normal)
            Mylog(emotion.pngPath ?? "这里没有找到")
            emotionBtn.setTitle(emotion.emojiCode, for: .normal)
            
            if emotion.isRemove {
                emotionBtn.setImage(UIImage(named: "compose_emotion_delete"), for: .normal)
            }
            
            if emotion.isEmpty {
                emotionBtn.setImage(UIImage(named: ""), for: .normal)
            }
            
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) has not been implemented")
    }
}

extension EmotionViewCell{
    func setupUI() {
        self.contentView.addSubview(emotionBtn)
        emotionBtn.frame = self.bounds
        emotionBtn.isUserInteractionEnabled = false
        emotionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 32)
    }
}
