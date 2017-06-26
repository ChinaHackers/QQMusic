//
//  QQMusicCell.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/24.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

/// 动画类型
///
/// - Rotation: 旋转
/// - Transition: 渐变
/// - Scale: 比例
enum AnimationType {
    case Rotation
    case Transition
    case Scale
}

class QQMusicCell: UITableViewCell {
    
    
    // MARK: -控件属性
    @IBOutlet weak var singerIconImageView: UIImageView!    // 歌手头像
    @IBOutlet weak var songNameLabel: UILabel!              // 歌曲名称
    @IBOutlet weak var singerNameLabel: UILabel!            // 歌手名称
    
    
    // MARK:- 定义模型属性
    var musicM: QQMusicModel? {
    // 监听模型改变
        didSet{
            
            // 设置基本信息
            singerIconImageView.image = UIImage(named: (musicM?.singerIcon)!)
            songNameLabel.text = musicM?.name
            singerNameLabel.text = musicM?.singer
        }
    }

    /// 加载XIB执行
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置头像圆角
        singerIconImageView.layer.cornerRadius = singerIconImageView.frame.size.width * 0.5
        singerIconImageView.layer.masksToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    /// 提供一个方法实现动画
    ///
    /// - Parameter type: 动画类型
    func aniation(type: AnimationType) -> () {
        
        if type == .Rotation {
            // 防止动画调用多次,首先移除动画
            self.layer.removeAnimation(forKey: "rotation")
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.values = [-1/6 * M_PI, 0, 1/6 * M_PI, 0]
            animation.duration = 0.2
            animation.repeatCount = 3
            self.layer.add(animation, forKey: "rotation")
        }
        if type == .Scale {
            // 防止动画调用多次,首先移除动画
            self.layer.removeAnimation(forKey: "scale")
            let animation = CAKeyframeAnimation(keyPath: "transform.scale.x")
            animation.values = [0.5, 1, 0.5, 1]
            animation.duration = 0.2
            animation.repeatCount = 2
            self.layer.add(animation, forKey: "scale")
            
        }
        
    }

}
