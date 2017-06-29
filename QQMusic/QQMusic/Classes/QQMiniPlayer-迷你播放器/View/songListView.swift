//
//  songListView.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/27.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

private let songListCell = "songListCell"


class songListView: UIView {

    @IBOutlet weak var tab: UITableView!
    
    /// 关闭按钮
    @IBOutlet weak var closeBtn: UIButton!

    /// 模型属性
    fileprivate var musicModels: [QQMusicModel] = [QQMusicModel]() {
        // 监听模型改变
        didSet {
            tab.reloadData()
        }
    }
    
    /// 加载XIB执行
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configUI()
        
        ExtractData()
        
    }
    
    /// 配置UI
    private func configUI() {
        
        tab.dataSource = self
//        tableView.delegate = self
        tab.register(UINib(nibName: "ListViewCell", bundle: nil), forCellReuseIdentifier: songListCell)
    }
    
    
    /// 取出数据
    private func ExtractData() {
        // 取出数据
        QQMusicDataTool.getMusicModels { (models: [QQMusicModel]) in
            //print(models)
            
            self.musicModels = models
            
            QQMusicOperationTool.shareInstance.musicMs = models
        }
    }
    
}

extension songListView {
    
    /// 提供一个通过 Xib 快速创建的类方法
    ///
    /// - Returns: songListView
    class func Load_songListView() -> songListView {
        return Bundle.main.loadNibNamed("songListView", owner: nil, options: nil)?.first as! songListView
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension songListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 取出模型
        let model = musicModels[indexPath.row]
        // 创建cell, 并赋值
        let cell = tableView.dequeueReusableCell(withIdentifier: songListCell, for: indexPath) as! ListViewCell
        cell.qqmusicMo = model
        return cell
    }
}
