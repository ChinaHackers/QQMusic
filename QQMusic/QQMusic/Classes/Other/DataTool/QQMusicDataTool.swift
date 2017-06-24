//
//  QQMusicDataTool.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/24.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit


/// 数据工具类
class QQMusicDataTool: NSObject {
    
    /// 类方法
    ///
    /// 解析歌曲信息
    ///
    /// - Parameter result: 返回结果
    class func getMusicModels(_ result: ([QQMusicModel])->()) {

        
        // 1.获取文件路径
        guard let path = Bundle.main.path(forResource: "Musics.plist", ofType: nil) else {
            result([QQMusicModel]())
            return
        }
        // 2.解析文件内容
        guard let array = NSArray(contentsOfFile: path) else {
            result([QQMusicModel]())
            return
        }

        
        // 3.解析(转换成歌曲模型)
        var models = [QQMusicModel]()
        for dic in array {
            let model = QQMusicModel(dict: dic as! [String : AnyObject])
            models.append(model)
        }

        // 4. 返回结果
        result(models)
    }
}
