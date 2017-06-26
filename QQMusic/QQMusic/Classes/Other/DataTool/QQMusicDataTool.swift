//
//  QQMusicDataTool.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/24.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit


/// 音乐数据工具类
class QQMusicDataTool: NSObject {
    
    // MARK: - 类方法
    
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

    /// 解析歌词信息
    ///
    /// - Parameter lrcName: 歌词文件名
    /// - Returns: QQLrcModel
    class func getLrcModels(lrcName: String?) -> [QQLrcModel] {

        if lrcName == nil {
            return [QQLrcModel]()  // 如何歌词为空, 返回空的数组
        }
        
        // 1. 获取文件的路径
        guard let path = Bundle.main.path(forResource: lrcName, ofType: nil) else {
            return [QQLrcModel]()  // 如何文件为空, 返回空的数组
        }

        /// 歌词内容
        var lrcContent = ""
        
        
        // 2. 读取文件的内容(即字符串)
        do {
             lrcContent = try String(contentsOfFile: path)
        } catch  {
            print(error)
            return [QQLrcModel]()
        }
        
        // 3. 解析字符串(转换成为QQLrcModel 组成的数组)
        print(lrcContent)
        
        // 3.1 先按照换行符, 分割成每一行字符串来处理
        /// 时间.内容: [00:00.89]传奇
        let timeContentArray = lrcContent.components(separatedBy: "\n")
        
        var resultMs = [QQLrcModel]()
        
        // 3.2 遍历每个字符串, 单独进行解析一个字符串
        for timeContentStr in timeContentArray {
            
            // [00:00.89]传奇
            // [ti:]
            // 过滤垃圾数据
            if timeContentStr.contains("[ti:") || timeContentStr.contains("[ar:") || timeContentStr.contains("[al:") {
                continue //执行后面的代码
            }

            // 在这里, 可以拿到真正对的格式的数据
            // [00:00.89]传奇
            // 去除左中括号
            // replacingOccurrences: 返回一个新字符串，其中接收器中目标字符串的所有事件都由另一个给定字符串替换。
            
            let resultLrcStr = timeContentStr.replacingOccurrences(of: "[", with: "")
            
            // 00:00.91]简单爱 resultLrcStr
            
            // components(separatedBy:): 方法是将字符串根据指定的字符串参数进行分割，并将分别的内容转换为一个数组
            
            let timeAndContent = resultLrcStr.components(separatedBy: "]")
           
            
            // 容错处理, 防止解析错误格式的数据, 造成崩溃
            if timeAndContent.count != 2 {
                continue
            }
            /// 时间
            let time = timeAndContent[0]
            /// 内容
            let content = timeAndContent[1]
            
            
            // 创建歌词数据模型, 赋值
            let lrcM = QQLrcModel()
            
            resultMs.append(lrcM)
            
            lrcM.beginTime = QQTimeTool.getTimeInterval(formatTime: time)  // 00:00.91
            
            lrcM.lrcContent = content
        }
        
        // 遍历数组, 给每个模型的结束时间赋值
        let count = resultMs.count
        
        for i in 0..<count {
            
            if i == count - 1 {
                continue
            }
            // 第一个模型
            let lrcM = resultMs[i]
            // 下一个模型
            let nextLrcM = resultMs[i + 1]
            
            lrcM.endTime = nextLrcM.beginTime
        }
        
        print(resultMs)
        
        // 4. 返回结果
        return resultMs
        
        
        
    }
    
    /// 告诉当前正在播放哪行歌词
    ///
    /// - Parameters:
    ///   - currentTime: 当前正在播放时间
    ///   - lrcModels: 告诉哪个数组里面取数据
    /// - Returns: 索引: 哪行 \ 模型
    class func getCurrentLrcM(currentTime: TimeInterval, lrcModels: [QQLrcModel]) -> (row: Int, lrcM: QQLrcModel?) {
        
        var index = 0
        
        // 遍历数组
        for lrcM in lrcModels {
            // 如果当前播放时间 >=  开始时间 并且 当前播放时间 < 结束时间
            if currentTime >= lrcM.beginTime && currentTime < lrcM.endTime {
                return (index, lrcM)
            }
            
            index += 1
        }
        
        return (0, nil)
    }
}
