//
//  QQListController.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/24.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit


/// 重用标识符
private let identifier = "music"

class QQListController: UITableViewController {
    
    /// 模型属性
    fileprivate var musicModels: [QQMusicModel] = [QQMusicModel]() {
        // 监听模型改变
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
        ExtractData()
    }
    
    /// 取出数据
    private func ExtractData() {
        // 取出数据
        QQMusicDataTool.getMusicModels { (models: [QQMusicModel]) in
            print(models)
            self.musicModels = models
        }
    }

    
}


// MARK: - Table view data source \   Table view dele gate
extension QQListController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return musicModels.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 取出模型, 给cell赋值
        let model = musicModels[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! QQMusicCell
        cell.musicM = model
        return cell
     }
    // 点击cell闪烁一下
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - 配置UI界面
extension QQListController {
    
    /// 配置UI界面
    fileprivate func configUI() {
        configTableView()
    }
    
    /// 配置UITableView
    private func configTableView() {
        tableView.rowHeight = 60
        tableView.backgroundView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        tableView.register(UINib(nibName: "QQMusicCell", bundle: nil), forCellReuseIdentifier: identifier)
    }
    // 设置状态栏风格
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}










