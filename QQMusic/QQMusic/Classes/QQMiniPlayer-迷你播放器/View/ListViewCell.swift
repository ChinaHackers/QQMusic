//
//  ListViewCell.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/28.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

class ListViewCell: UITableViewCell {
    
    
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var singerLabel: UILabel!
    
    
    // MARK: - 定义模型属性
    var qqmusicMo: QQMusicModel? {
        // 监听模型改变
        didSet {
            
            // 设置基本信息
            songNameLabel.text = qqmusicMo?.name
            songNameLabel.adjustsFontSizeToFitWidth = true  // 自动根据字体计算标签的宽度
            
            singerLabel.text = qqmusicMo?.singer
            singerLabel.adjustsFontSizeToFitWidth = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
