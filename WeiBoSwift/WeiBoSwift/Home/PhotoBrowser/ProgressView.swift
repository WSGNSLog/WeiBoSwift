//
//  ProgressView.swift
//  WeiBoSwift
//
//  Created by user on 2019/3/25.
//  Copyright © 2019 Wu. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    var progress : CGFloat = 0{
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        //获取参数
        let center = CGPoint(x: rect.width * 0.5, y: rect.height * 0.5)
        let radius = rect.width * 0.5 - 3
        let startAngle = CGFloat(-Double.pi / 2)
        let endAngle = CGFloat(2 * Double.pi) * progress + startAngle
        
        //创建贝塞尔曲线
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        //绘制一条中心点的线
        path.addLine(to: center)
        path.close()
        
        //设置绘制的颜色
        UIColor.red.setFill()
        
        //开始绘制
        path.fill()
    }

}
