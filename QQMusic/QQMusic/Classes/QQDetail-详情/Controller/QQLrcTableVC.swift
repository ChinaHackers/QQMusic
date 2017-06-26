//
//  QQLrcTableVC.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/26.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit


/// 重用标识符
private let LrcCell = "lrcID"

/// 歌词表格视图
class QQLrcTableVC: UITableViewController {
    
    
    // 提供给外界的数值, 代表需要滚动的行数
    var scrollRow = -1 {
        didSet {
            
            // 过滤值, 降低滚动频率
            // 如果两个值相等, 代表滚动的是同一行, 没有必要滚动很多次
            if scrollRow == oldValue {
                return
            }

            // 先刷新表格
            let indexPaths = tableView.indexPathsForVisibleRows
            tableView.reloadRows(at: indexPaths!, with: .fade)
            
            // 再带动画滚动表格
            let indexPath = IndexPath(row: scrollRow, section: 0)
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)

        }
    
    }
    
    // 提供给外界赋值的进度
    var progress: CGFloat = 0 {
        didSet {
            
            // 拿到当前正在播放的cell
            let index = IndexPath(row: scrollRow, section: 0)
            let cell = tableView.cellForRow(at: index) as? QQLrcCell
            
            // 给cell里面label的进度赋值
            cell?.progress = progress
            
        }
    }
    
    
    // 提供给外界的数据源
    var lrcModels: [QQLrcModel] = [QQLrcModel]() {
        didSet{
            tableView.reloadData()
        }
    }
    

    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
    }
    
    // 控制器的view将要布局子控件完成时, 调用
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // 调整内边距, 让顶部和底部的歌词行可以滚动到中间
        tableView.contentInset = UIEdgeInsetsMake(tableView.frame.size.height * 0.5, 0, tableView.frame.size.height * 0.5, 0)
    }
    
    
    /// 配置UITableView
    private func configTableView() {
        tableView.separatorStyle = .none        // 去除分割线
        tableView.allowsSelection = false       // 不允许选中
        tableView.register(UINib(nibName: "QQLrcCell", bundle: nil), forCellReuseIdentifier: LrcCell)
    }
}

// MARK: - Table view data source
extension QQLrcTableVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lrcModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 取出模型
        let model = lrcModels[indexPath.row]

        // 创建cell
        let cell = tableView.dequeueReusableCell(withIdentifier: LrcCell, for: indexPath) as! QQLrcCell
        
        if indexPath.row == scrollRow { // 如果当前行处于滚动行数
            cell.progress = progress
        }else {
            cell.progress = 0
        }
        
        // cell展示
        cell.lrcContent = model.lrcContent
        return cell
    }

    
}
