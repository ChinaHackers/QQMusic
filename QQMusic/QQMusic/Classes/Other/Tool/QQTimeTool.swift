//
//  QQTimeTool.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/24.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

/// 时间工具类
class QQTimeTool: NSObject {

    
    /// 目的: 根据 秒数 转换为格式化后的 字符串
    ///
    /// - Parameter timeInterval: 秒数
    /// - Returns: 格式化后的字符串
    class func getFormatTime(timeInterval: TimeInterval) -> String {
        
        // timeInterval 21.123
        let min = Int(timeInterval) / 60
        let sec = Int(timeInterval) % 60
        
        return String(format: "%02d: %02d", min, sec)
    }
}
