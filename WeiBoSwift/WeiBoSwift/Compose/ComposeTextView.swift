//
//  ComposeTextView.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/29.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

class ComposeTextView: UITextView {

    lazy var label : UILabel = UILabel()///占位label
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupPlaceHolder("分享新鲜事")
        self.alwaysBounceVertical = true
        textContainerInset = UIEdgeInsets(top: 8, left: 7, bottom: 0, right: 7)
    }
}

extension ComposeTextView{
    
    
    /// 给自己设置一个占位文字
    ///
    /// - Parameter placeholder: 占位文字
    fileprivate func setupPlaceHolder(_ placeholder : String){
        
        self.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(8)
            make.left.equalTo(self).offset(10)
        }
        
        label.text = placeholder
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 14)
    }
}
