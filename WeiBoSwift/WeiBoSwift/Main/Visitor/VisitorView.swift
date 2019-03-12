//
//  VisitorView.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/9.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

class VisitorView: UIView {

    class func visitorView() -> VisitorView {
    
        return Bundle.main.loadNibNamed("VisitorView", owner: nil, options: nil)?.first as! VisitorView
    }

    @IBOutlet weak var iconView: UIImageView!
    
    @IBOutlet weak var rotateView: UIImageView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    func setupVisitorViewInfo(iconName : String, title : String) {
        iconView.image = UIImage(named: iconName)
        tipLabel.text = title
        rotateView.isHidden = true
    }
    
    func addRotateionAnimation() {
        let rotateAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnim.fromValue = 0
        rotateAnim.toValue = Double.pi * 2
        rotateAnim.repeatCount = MAXFLOAT
        rotateAnim.duration = 5
        rotateAnim.isRemovedOnCompletion = false
        rotateView.layer.add(rotateAnim, forKey: nil)
    }
    
}
