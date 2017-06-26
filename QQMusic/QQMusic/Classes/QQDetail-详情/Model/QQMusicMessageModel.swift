//
//  QQMusicMessageModel.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/12.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

/// 音乐信息模型
class QQMusicMessageModel: NSObject {
    
    
    var musicM: QQMusicModel?
    
    /// 已经播放时间
    var costTime: TimeInterval = 0
    
    /// 总时长
    var totalTime: TimeInterval = 0
    
    /// 播放状态
    var isPlaying: Bool = false
}
