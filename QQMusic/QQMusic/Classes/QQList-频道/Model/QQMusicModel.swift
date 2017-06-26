//
//  QQMusicModel.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/24.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

class QQMusicModel: NSObject {
    
    // MARK: 定义属性
    /// 歌曲名
    var name: String?
    
    /// 歌曲文件名
    var filename: String?
    
    /// 歌词文件名
    var lrcname: String?
    
    /// 歌手
    var singer: String?
    
    /// 歌手头像
    var singerIcon: String?
    
    /// 专辑头像
    var icon: String?

    // MARK: 定义字典转模型的构造函数
    init(dict: [String: Any]) {
        super.init()
        
        // 使用KVC字典转模型
        setValuesForKeys(dict)
    }
    
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
