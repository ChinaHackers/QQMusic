//
//  SliderView.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/7/1.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

/// 歌词视图中滑块播放View
class SliderView: UIView {

    // MARK: - 控件属性
    /// 提示标签
    @IBOutlet weak var tipLabel: UILabel!
    /// 播放时间标签
    @IBOutlet weak var timeLabel: UILabel!
    /// 播放按钮
    @IBOutlet weak var playBttuon: UIButton!
   
    var time: TimeInterval?
    
    
  
    /// 播放按钮点击事件
    ///
    /// - Parameter sender: 按钮对象
    @IBAction func PlayBtnClicked(_ sender: UIButton) {

        // 先隐藏滑块View
//        isHidden = true

        // 设置歌曲播放到对应的 滑块 时间点
        QQMusicOperationTool.shareInstance.seekToTime(time!)
    }

}

extension SliderView {
    
    /// 提供一个通过 Xib 快速创建滑块视图的类方法
    ///
    /// - Returns: SliderView
    class func Load_SliderView() -> SliderView {
        return Bundle.main.loadNibNamed("SliderView", owner: nil, options: nil)?.first as! SliderView
    }
    
    /// 设置时间
    ///
    /// - Parameter time: 时间间隔
    func setTime(_ timeInterval: TimeInterval) {
        
        self.time = timeInterval
        
        // 滚动条显示的这行歌词的开始时间
        timeLabel.text = QQTimeTool.getFormatTime(timeInterval: timeInterval)
    }

    
}
