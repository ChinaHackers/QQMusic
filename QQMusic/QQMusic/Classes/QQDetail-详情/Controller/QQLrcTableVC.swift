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
    
    /// 歌词视图中的滑块
    var sliderView: SliderView = {
        let sliderView = SliderView.Load_SliderView()
        return sliderView
    }()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        configUI()
    }
    
    // 控制器的view将要布局子控件完成时, 调用
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // 调整内边距, 让顶部和底部的歌词行可以滚动到中间
        tableView.contentInset = UIEdgeInsetsMake(tableView.frame.size.height * 0.5, 0, tableView.frame.size.height * 0.5, 0)
    }
    
}

// MARK: - 配置UI
extension QQLrcTableVC {
    
    /// 配置UI界面
    fileprivate func configUI() {
        
        configTableView()
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
            cell.lrcLabel.font = UIFont.systemFont(ofSize: 17) //字体放大
        }else {
            cell.progress = 0
            cell.lrcLabel.font = UIFont.systemFont(ofSize: 15) //字体放大
        }
        
        // cell展示
        cell.lrcContent = model.lrcContent
        return cell
    }

}


// MARK: - UIScrollViewDelegate
extension QQLrcTableVC {
    
    // 当用户拖动 ScrollView 导致 contentOffset 改变的时候就会调用
    /// 目的: 监听滚动视图的滚动, 做透明动画效果
    ///
    /// - Parameter scrollView: 滚动视图
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        /*
         contentOffset: 即偏移量,contentOffset.y = 内容的顶部和frame顶部的差值,contentOffset.x = 内容的左边和frame左边的差值.
         contentInset:  即内边距,contentInset = 在内容周围增加的间距(粘着内容),contentInset的单位是UIEdgeInsets
         */
        
        /// 表格视图行高
        let tabHeight: CGFloat = 44.0
        
        // 获取滚动位置的歌词索引
        var offSetX = Int((tableView.contentOffset.y + tableView.contentInset.top) / tabHeight)
        
        if offSetX < 0 {  // 防止行数为负数, 越界
            offSetX = 0
        } else if offSetX > lrcModels.count - 1 {
            offSetX = lrcModels.count - 1
        }
        
        let lrcT = lrcModels[offSetX]
        
        // 给歌词滑块视图, 设置用户拖动到的那行歌词的开始时间
        sliderView.setTime(lrcT.beginTime)
    }
    
    
    /// 开始拖拽时, 调用
    ///
    /// - Parameter scrollView: 滚动视图
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        sliderView.isHidden = false
    }
    
    
    /// 结束拖拽时 (用户已经松开手指), 调用
    ///
    /// - Parameters:
    ///   - scrollView: 滚动视图
    ///   - velocity: 速度
    ///   - targetContentOffset: 目标内容偏移
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // 延迟5秒执行
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            
            // 如果没有拖动
            if scrollView.isDragging == false {
                self.sliderView.isHidden = true
            }
        }
    }
    
    
}

