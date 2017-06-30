//
//  QQMusicTool.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/24.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit
import AVFoundation



let kPlayFinishNotification = "playFinish"

/// 音乐工具类: 负责,单首歌曲的操作, 播放, 暂停, 停止, 快进, 倍数..
class QQMusicTool: NSObject {

    var player: AVAudioPlayer?
    
    
    override init() {
        super.init()
        // 只要调用这个工具类创建对象, 就立刻 激活 后台播放
        
        // 1. 获取音频会话
        let session = AVAudioSession.sharedInstance()
        
        do {
            // 2.设置音频会话类型(后台播放)
            try session.setCategory(AVAudioSessionCategoryPlayback)
            
            // 3.激活会话
            try session.setActive(true)
            
        } catch {
            print(error)
            return
        }
    
    }
    
    
    
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
            player?.delegate = self
            
            // 3.准备播放
            player?.prepareToPlay()
            
            // 4.开始播放
            player?.play()
        }catch {
            print(error)
            return
        }

    }
    
    
    /// 类方法: 暂停音乐
    func pauseMusic() {
        player?.pause()
    }
    
    /// 寻找到正确的时间
    ///
    /// - Parameter time: 时间间隔
    func seekToTime(_ time: TimeInterval) {
        // 当前时间赋值给time
        player?.currentTime = time
    }
    
    
    
}

// MARK: - 遵守 AVAudioPlayerDelegate 协议
extension QQMusicTool: AVAudioPlayerDelegate {
    
    /// 音乐播放器播放完成
    ///
    /// - Parameters:
    ///   - player: AVAudioPlayer对象
    ///   - flag: 成功
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
     
        print("播放完成...")
        
        // 由于事件要多级传递，所以才用通知，代理和回调其实也是可以的
    /*
         name:   一般情况下需要定义成一个常量, 如：kNotiAddPhoto
         object:（谁发送的通知）一般情况下可以不传，置为nil表示<匿名发送>
    */
        // 发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPlayFinishNotification), object: nil)
    }
}


