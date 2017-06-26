//
//  QQMusicOperationTool.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/24.
//  Copyright © 2017年 LC. All rights reserved.
//




import UIKit

 // QQMusicOperationTool类: 控制的是播放的业务逻辑, 具体的播放, 暂停功能实现(QQMusicTool)

class QQMusicOperationTool: NSObject {

    
    /// 音乐信息模型对象
    private var musicModel = QQMusicMessageModel()
    
    
    /// 获取音乐信息模型
    ///
    /// - Returns: QQMusicMessageModel
    func getMusicMessageModel() -> QQMusicMessageModel {
        
        // 在这里, 保持, 数据的最新状态, 就可以
       
        // 当前正在播放的歌曲信息
        musicModel.musicM = musicMs[currentPlayIndex]
        
        // 已经播放的时间
        musicModel.costTime = (tool.player?.currentTime) ?? 0
        
        print("已经播放的时间为: \(musicModel.costTime)")
        
        // 总时长
        musicModel.totalTime = (tool.player?.duration) ?? 0
        
        // 播放状态
        musicModel.isPlaying = (tool.player?.isPlaying) ?? false
        
        return musicModel
    }
    
    
    /// 当前索引
    var currentPlayIndex = -1 {
        didSet { //属性监视器  
            // 循环播放
            if currentPlayIndex < 0 {
                currentPlayIndex = (musicMs.count) - 1
            }
            if currentPlayIndex > (musicMs.count) - 1 {
                currentPlayIndex = 0
            }
        }
   
    }
    
    
    /// 单例
    static let shareInstance = QQMusicOperationTool()
    
    /// 音乐工具类对象
    let tool = QQMusicTool()
    
    
    /// 播放的音乐列表模型对象
    var musicMs: [QQMusicModel] = [QQMusicModel]()
    
    func playMusic(musicM: QQMusicModel) {
        
        // 播放数据模型对应的音乐
        tool.playMusic(musicName: musicM.filename)
      
        // 当前索引 = 模型在数组中的索引
        currentPlayIndex = musicMs.index(of: musicM)!
    }
    
    /// 播放当前音乐
    func playCurrentMusic() -> () {
        // 取出需要播放的音乐数据模型
        let model = musicMs[currentPlayIndex]
        
        // 播放音乐模型
        playMusic(musicM: model)
        
    }
    
    /// 暂停当前音乐
    func pauseCurrentMusic() -> () {

        // 根据音乐模型, 进行暂停
        tool.pauseMusic()
        
    }
    
    /// 下一首
    func nextMusic() {

        currentPlayIndex += 1

        // 取出需要播放的音乐数据模型
        let model = musicMs[currentPlayIndex]

        // 根据音乐模型, 进行播放
        playMusic(musicM: model)
        
    }
    
    /// 上一首
    func PreviousMusic() -> () {
        
        currentPlayIndex -= 1

        // 取出需要播放的音乐数据模型
        let model = musicMs[currentPlayIndex]
        
        // 根据音乐模型, 进行播放
        playMusic(musicM: model)
        
    }

   
    
}
