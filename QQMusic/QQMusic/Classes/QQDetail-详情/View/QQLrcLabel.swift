//
//  QQLrcLabel.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/26.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit


/// 歌词Label
class QQLrcLabel: UILabel {

    var radio: CGFloat = 0.0 {
        didSet {
            setNeedsDisplay()   //执行重绘
        }
    }
    
    //通过DrawRect方法获取Label的图形上下文,使用混合填充的方式实现Label绘制颜色
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 设置一个颜色
        UIColor.green.set()
        
        let x = rect.origin.x
        let y = rect.origin.y
        let w = rect.size.width * radio
        let h = rect.size.height
        
        let fillRect = CGRect(x: x, y: y, width: w, height: h)
        
        // 渲染
        
        /*
         kCGBlendModeNormal公式: R = S + D*(1 - Sa) --> 结果 = 源颜色 + 目标颜色 * (1-源颜色各透明组件的透明度)
         在这里;
         源颜色  -->  就是要绘制上去的颜色/填充色  ([[UIColor greenColor] setFill];)
         目标颜色 --> Label当前的颜色(白色和透明),上下文中已经有的颜色
         
         */
        // 在某个区域中使用混合模式进行填充
        UIRectFillUsingBlendMode(fillRect, .sourceIn)
        
    }

}
