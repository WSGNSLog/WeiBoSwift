//
//  ComposeTitleView.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/29.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

class ComposeTitleView: UIView {

    fileprivate lazy var titleLabel : UILabel = UILabel()
    fileprivate lazy var screenNameLabel : UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ComposeTitleView{
    fileprivate func setupUI(){
        
        self.addSubview(titleLabel)
        self.addSubview(screenNameLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        screenNameLabel.font = UIFont.systemFont(ofSize: 14)
        screenNameLabel.textColor = UIColor.lightGray
        
        titleLabel.text = "发微博"
        screenNameLabel.text = UserAccountViewModel.shareInstance.account?.screen_name ?? "weibo"
    }
}
