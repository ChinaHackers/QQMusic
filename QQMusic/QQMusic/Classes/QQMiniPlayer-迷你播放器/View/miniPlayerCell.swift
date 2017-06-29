//
//  miniPlayerCell.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/27.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

class miniPlayerCell: UICollectionViewCell {

    // MARK: - 控件属性
    
    /// 歌手头像
    @IBOutlet weak var imageView: UIImageView!
    
    /// 歌曲名称
    @IBOutlet weak var songNameLabel: UILabel!
    
    /// 歌手名称
    @IBOutlet weak var singerNameLabel: UILabel!
    
    // MARK: - 定义模型属性
    var qqmusicMo: QQMusicModel? {
        // 监听模型改变
        didSet {
            
            // 设置基本信息
            imageView.image = UIImage(named: (qqmusicMo?.singerIcon)!)
            songNameLabel.text = qqmusicMo?.name
            singerNameLabel.text = qqmusicMo?.singer
        }
    }
    
    /// 加载XIB执行
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置头像圆角
        imageView.layer.cornerRadius = imageView.frame.size.width * 0.5
        imageView.layer.masksToBounds = true
        addRotationAimation()
    }
}

// MARK: - 制作动画
extension miniPlayerCell {
    
    
    /// 添加旋转动画
    func addRotationAimation() {
        
        // 防止动画添加多次, 首先移除
        imageView.layer.removeAnimation(forKey: "rotation")
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0                 // 从0开始旋转
        animation.toValue = M_PI * 2            // 旋转360度
        animation.duration = 30                 // 旋转持续的时间
        animation.isRemovedOnCompletion = false // 动画完成后是否删除
        animation.repeatCount = MAXFLOAT        // 无限旋转
        
        // 添加动画
        imageView.layer.add(animation, forKey: "rotation")
    }
    
    
    
    /// 暂停旋转动画
    func pauseRotationAnimation() -> () {
        imageView.layer.pauseAnimate()
    }
    
    /// 继续旋转动画
    func resumeRotationAnimation() -> () {
        imageView.layer.resumeAnimate()
    }
    
    
    
}
