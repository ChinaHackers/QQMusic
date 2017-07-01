//
//  QQImageTool.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/24.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

/// 图片工具类
class QQImageTool: NSObject {

    /// 利用一个图片\文字, 绘制成新的图片
    ///
    /// - Parameters:
    ///   - sourceImage:图片
    ///   - str: 文字
    /// - Returns: UIImage对象
    class func getNewImage(_ sourceImage: UIImage?, str: String?) -> UIImage? {
        
        // 0. 容错处理
        guard let image = sourceImage else { return nil }
        guard let resultStr = str else { return image }
        
        let size = image.size
        
        // 1. 开启图形上下文
        UIGraphicsBeginImageContext(size)
        
        // 2. 绘制大图片
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        
        // 3. 绘制文字
        /// NSMutableParagraphStyle: 段落样式
        let style = NSMutableParagraphStyle()
        style.alignment = .center
       
        /// 文本的frame
        let textRect = CGRect(x: 0, y: size.height * 0.8, width: size.width, height: 20)
        
        // 定义不可变字典,存储段落的属性
        let textDic = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.systemFont(ofSize: 18),
            NSParagraphStyleAttributeName: style
        ]
        
        // 利用文本的frame 绘制文字
        (resultStr as NSString).draw(in: textRect, withAttributes: textDic)
        
        // 4. 取出图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭图形上下文
        UIGraphicsEndImageContext()
        
        return resultImage
    }
    
}
