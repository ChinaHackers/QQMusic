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
    
    /// 光晕视图
    @IBOutlet weak var HaloView: UIView!
    
// ===========================
// MARK: - 更新 1 次
// ===========================
    
    /// 背景图片
    @IBOutlet weak var backImageView: UIImageView!
    
    /// 圆形背景图片->前景图片
    @IBOutlet weak var RoundBackground: UIImageView!
    
    /// 歌曲名称
    @IBOutlet weak var songNameLabel: UILabel!
    
    /// 歌手名称
    @IBOutlet weak var singerNameLabel: UILabel!
    
    /// 总时长
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    
// ===========================
// MARK: - 更新 n 次
// ===========================
    
    /// 歌词label
    @IBOutlet weak var lrcLabel: UILabel!
    
    /// 进度条
    @IBOutlet weak var progressSlider: UISlider!
    
    /// 已经播放时长
    @IBOutlet weak var costTimeLabel: UILabel!
    

    
    // 负责更新很多次的timer
    var timer: Timer?
    
    
    
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
    
    // 视图即将加入窗口时调用
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UpdateOnce()
        addTimer()
    }
    
    // 视图即将消失、被覆盖或是隐藏时调用
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeTimer()
    }
    

    /// 关闭按钮点击事件
    @IBAction func closeButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
    /// 播放或者暂停
    @IBAction func playOrPause(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected //按钮状态取反
        
        if sender.isSelected { // 播放
            
            QQMusicOperationTool.shareInstance.playCurrentMusic()
            resumeRotationAnimation()
            
        }else {                // 暂停
            
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
            pauseRotationAnimation()
        }
    }
    
    /// 上一首
    @IBAction func PreviousMusic() {
        // 1.切换歌曲: 下一首
        QQMusicOperationTool.shareInstance.PreviousMusic()
       
        // 2. 切换一次更新界面的操作
        UpdateOnce()
    }
    
    /// 下一首
    @IBAction func nextMusic() {
        // 1.切换歌曲: 下一首
        QQMusicOperationTool.shareInstance.nextMusic()
        
        // 2.切换一次更新界面
        UpdateOnce()
    }

    /// 切换歌曲时, 需要更新 1 次的操作
    private func UpdateOnce() {
        
        // 创建音乐信息模型对象
        let musicMessageModel = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        
        
        guard let musicM = musicMessageModel.musicM else {return}
        
        guard musicM.icon != nil else { return }
    
        backImageView.image = UIImage(named: (musicM.icon)!)
        RoundBackground.image = UIImage(named: (musicM.icon)!)
        songNameLabel.text = musicM.name
        singerNameLabel.text = musicM.singer
        
        // 212.0988 -> 04:56
        totalTimeLabel.text = QQTimeTool.getFormatTime(timeInterval: musicMessageModel.totalTime)
    }


    /// 切换歌曲时, 需要更新 N 次的操作
    @objc private func Update_N_Times() {

//        lrcLabel.text = ""
        
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        
        
        // 进度条值 = 已播放时间 / 总时长
        progressSlider.value = Float(musicMessageM.costTime / musicMessageM.totalTime)
        
        /** 已经播放时长 n*/
        costTimeLabel.text = QQTimeTool.getFormatTime(timeInterval: musicMessageM.costTime)
    }
    
    
    /// 执行多次更新-添加定时器
    private func addTimer() {
        
        // timeInterval: 时间间隔
        // repeats: 是否重复
        timer = Timer(timeInterval: 1, target: self, selector: #selector(Update_N_Times), userInfo: nil, repeats: true)
        
        // 将定时器加入运行循环
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    /// 移除定时器
    private func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
}


// MARK: - 配置UI界面
extension QQDetailController {
    
    /// 配置UI界面
    fileprivate func configUI() {
        
        // 隐藏导航栏
        navigationController?.isNavigationBarHidden = true
        
        configScrollView()
        configRoundBackground()
        configHaloView()
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
    
    /// 配置圆形前景图片
    private func configRoundBackground() {
        
        // 设置图层的圆角边框大小
        RoundBackground.layer.cornerRadius = RoundBackground.frame.size.width * 0.5
        // 是否开启圆角效果
        RoundBackground.layer.masksToBounds = true
    }
    
    /// 配置进度条
    private func configProgressSlider() {
        // 设置圆形把手默认状态下的图片
        progressSlider.setThumbImage(UIImage(named: "player_slider_playback_thumb"), for: .normal)
    }
    
    /// 配置光晕视图
    private func configHaloView() {
        
        // 设置图层的圆角边框大小
        HaloView.layer.cornerRadius = HaloView.frame.size.width * 0.5
        // 是否开启圆角效果
        HaloView.layer.masksToBounds = true
        
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
        RoundBackground.alpha = radio
        lrcLabel.alpha = radio
        HaloView.alpha = radio
    }
    
    /// 暂停旋转动画
    fileprivate func pauseRotationAnimation() -> () {
        RoundBackground.layer.pauseAnimate()
    }
    
    /// 继续旋转动画
    fileprivate func resumeRotationAnimation() -> () {
        RoundBackground.layer.resumeAnimate()
    }
    

    
    
}











