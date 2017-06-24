//
//  QQMusicCell.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/24.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

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

}
