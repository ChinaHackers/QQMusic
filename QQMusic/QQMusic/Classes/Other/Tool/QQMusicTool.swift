//
//  QQMusicTool.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/24.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit
import AVFoundation


// MARK: - QQMusicTool类: 负责,单首歌曲的操作, 播放, 暂停, 停止, 快进, 倍数..
class QQMusicTool: NSObject {

    var player: AVAudioPlayer?
    
    
    /// 提供一个方法播放歌曲
    ///
    /// - Parameter musicName: 歌曲名称
    func playMusic(musicName: String?) {
        
        // 1.获取需要播放的音乐文件路径
        guard let url = Bundle.main.url(forResource: musicName, withExtension: nil) else { return }
        
        // 如果正在播放同一首歌曲,继续播放
        if player?.url == url {
            player?.play()
            return
        }
        
        // 2.根据文件路径创建播放器
        do {
            player = try AVAudioPlayer(contentsOf: url)
            // 准备播放
//            player?.prepareToPlay()
            // 开始播放
//            player?.play()
        }catch {
            print(error)
            return
        }
        
        // 3.准备播放
        player?.prepareToPlay()
        
        // 4.开始播放
        player?.play()
        
        
    }
    
    
    /// 类方法: 暂停音乐
    func pauseMusic() {
        player?.pause()
    }
    
    
}
