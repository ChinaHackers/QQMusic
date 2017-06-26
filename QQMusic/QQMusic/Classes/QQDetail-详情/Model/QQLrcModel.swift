//
//  QQLrcModel.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/26.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

/// 歌词模型
class QQLrcModel: NSObject {
    
    /// 开始时间
    var beginTime: TimeInterval = 0
    
    /// 结束时间
    var endTime: TimeInterval = 0
    
    /// 歌词内容
    var lrcContent: String = ""
}
