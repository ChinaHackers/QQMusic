//
//  QQLrcCell.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/26.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit


/// 歌词cell
class QQLrcCell: UITableViewCell {
    
    /// 歌词Label
    @IBOutlet weak var lrcLabel: QQLrcLabel!
    
    /// 进度
    var progress: CGFloat = 0 {
        didSet {
            lrcLabel.radio = progress
        }
    }
    
    /// 歌词内容
    var lrcContent: String = "" {
        didSet {
            lrcLabel.text = lrcContent
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
