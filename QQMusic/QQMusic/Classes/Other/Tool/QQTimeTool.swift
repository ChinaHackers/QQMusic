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
    
    /// 根据 字符串 转换成 秒数
    ///
    /// - Parameter formatTime: 格式化字符串
    /// - Returns: 秒数
    class func getTimeInterval(formatTime: String) -> TimeInterval {
        
        // 00:00.91
        
        //components(separatedBy:): 方法是将字符串根据指定的字符串参数进行分割，并将分别的内容转换为一个数组
        let minSec = formatTime.components(separatedBy: ":")
        
        if minSec.count != 2 {
            return 0
        }
        
        let min = TimeInterval(minSec[0]) ?? 0.0
        let sec = TimeInterval(minSec[1]) ?? 0.0
        
        return min * 60.0 + sec
    }
}
