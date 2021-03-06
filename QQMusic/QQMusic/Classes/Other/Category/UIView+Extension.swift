//
//  UIView+Extension.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/25.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit


// MARK:- 定义全局常量
let screenW = UIScreen.main.bounds.width    // 屏幕的宽度
let screenH = UIScreen.main.bounds.height   // 屏幕的高度
let statusH: CGFloat = 20                   // 状态栏的高度
let navigationH: CGFloat = 44               // 导航栏的高度
let tabBarH: CGFloat = 49                   // 标签栏的高度
let scrollLineH: CGFloat = 2                // 底部滚动滑块的高度
let titleViewH: CGFloat = 44                // 标题滚动视图的高度
let CycleViewHeight = screenW * 3 / 6       // 轮播图高度
let refresh_HeaderViewHeight: CGFloat = 90  // 刷新视图高度
let refresh_FooterViewHeight: CGFloat = 60  // 底部加载更多视图高度
let SpreadMaxH:CGFloat = screenH - 64       // 默认下拉展开的最大高度

let darkGreen = UIColor(hue:0.40, saturation:0.78, brightness:0.68, alpha:1.00)          //全局颜色:暗绿


func RGB(_ R: CGFloat, G: CGFloat, B: CGFloat) -> UIColor {
    return UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: 1.0)
}


func RGBA(_ R: CGFloat, G: CGFloat, B: CGFloat, A: CGFloat) -> UIColor {
    return UIColor(red: R/255.0, green: G/255.0, blue: B/255.0, alpha: A)
}



