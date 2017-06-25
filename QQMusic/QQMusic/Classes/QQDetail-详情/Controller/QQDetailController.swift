//
//  QQDetailController.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/24.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

class QQDetailController: UIViewController {

    // MARK: - 控件属性
    
    /// 滚动视图
    @IBOutlet weak var scrollView: UIScrollView!
    
    /// 背景图片
    @IBOutlet weak var backImageView: UIImageView!
    
    /// 歌词label
    @IBOutlet weak var lrcLabel: UILabel!
    
    /// 光晕图片
    @IBOutlet weak var HaloImageView: UIImageView!
    
    /// 进度条
    @IBOutlet weak var progressSlider: UISlider!
    
    
    // MARK: - 懒加载
    /// 歌词View
    fileprivate lazy var lrcView: UIView = {[weak self] in
        let lrcView = UIView(frame: (self?.scrollView.bounds)!)
        lrcView.backgroundColor = .clear
        lrcView.frame.origin.x = screenW // 使得歌词View默认在屏幕之外
        return lrcView
    }()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configUI()
    }

}


// MARK: - 配置UI界面
extension QQDetailController {
    
    /// 配置UI界面
    fileprivate func configUI() {
        
        // 隐藏导航栏
        navigationController?.isNavigationBarHidden = true
        
        configScrollView()
        configBackImageView()
        configProgressSlider()
    }
    
    /// 配置ScrollView
    private func configScrollView() {
        
        // 添加歌词View到scrollView中
        scrollView.addSubview(lrcView)
        
        // 设置scrollView相关属性
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: screenW * 2, height: 0)
    }
    
    /// 配置背景图片
    private func configBackImageView() {
        // 设置图层的圆角边框大小
        backImageView.layer.cornerRadius = backImageView.frame.size.width * 0.5
        
        // 是否开启圆角效果
        backImageView.layer.masksToBounds = true
    }
    
    /// 配置进度条
    private func configProgressSlider() {
        // 设置圆形把手默认状态下的图片
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: .normal)
    }
    
}


// MARK: - 遵守 UIScrollViewDelegate 协议
extension QQDetailController: UIScrollViewDelegate {
    
    // MARK: 做动画
    // scrollView滚动的时候就会调用。
    // 准确的说是用户拖动导致 contentOffset 改变的时候就会调用
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        /*
         contentOffset: 即偏移量,contentOffset.y = 内容的顶部和frame顶部的差值,contentOffset.x = 内容的左边和frame左边的差值.
         contentInset:  即内边距,contentInset = 在内容周围增加的间距(粘着内容),contentInset的单位是UIEdgeInsets
         */
        
        // 获取当前的移动量
        let offSetX = scrollView.contentOffset.x
        
        /// 计算移动的比例
        let radio = 1 - offSetX / scrollView.frame.size.width
        
        // 0.0 - 1.0
        backImageView.alpha = radio
        lrcLabel.alpha = radio
        HaloImageView.alpha = radio
        
    }
}
















