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

    
    /*
    private var musicModel = QQMusicMessageModel()
    
    func getMusicMessageModel() -> QQMusicMessageModel {
        
        // 在这里, 保持, 数据的最新状态, 就可以
        // 当前正在播放的歌曲信息
        musicModel.musicM = musicMs[currentPlayIndex]
        
        musicModel.costTime = (tool.player?.currentTime) ?? 0
        print(musicModel.costTime)
        musicModel.totalTime = (tool.player?.duration) ?? 0
        
        musicModel.isPlaying = (tool.player?.playing) ?? false
        
        
        return musicModel
        
    }
    
    var currentPlayIndex = -1 {
        didSet {
            if currentPlayIndex < 0
            {
                currentPlayIndex = (musicMs.count) - 1
            }
            if currentPlayIndex > (musicMs.count) - 1
            {
                currentPlayIndex = 0
            }
        }
   
    }
    
 */
    
    /// 单例
    static let shareInstance = QQMusicOperationTool()
    
    let tool = QQMusicTool()
    
    
    // 播放的音乐列表
    var musicMs: [QQMusicModel] = [QQMusicModel]()
    
    func playMusic(musicM: QQMusicModel) -> () {
        
        // 播放数据模型对应的音乐
        tool.playMusic(musicName: musicM.filename)
//        currentPlayIndex = musicMs.indexOf(musicM)!
    }
    
    /*
    func playCurrentMusic() -> () {
        // 取出需要播放的音乐数据模型
        let model = musicMs[currentPlayIndex]
        
        // 播放音乐模型
        playMusic(model)
        
    }
    
    func pauseCurrentMusic() -> () {

        // 根据音乐模型, 进行暂停
        tool.pauseMusic()
        
    }
    
    
    func nextMusic() -> () {
        
        currentPlayIndex += 1
        
        // 取出需要播放的音乐数据模型
        let model = musicMs[currentPlayIndex]
        
        // 根据音乐模型, 进行播放
        playMusic(model)
        
    }
    
    
    func preMusic() -> () {
        
        currentPlayIndex -= 1
        
        // 取出需要播放的音乐数据模型
        let model = musicMs[currentPlayIndex]
        
        // 根据音乐模型, 进行播放
        playMusic(model)
        
    }

   */
    
}
