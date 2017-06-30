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
    @IBOutlet weak var lrcLabel: QQLrcLabel!
    
    /// 进度条
    @IBOutlet weak var progressSlider: UISlider!
    
    /// 已经播放时长
    @IBOutlet weak var costTimeLabel: UILabel!
    
    /// 播放\暂停按钮
    @IBOutlet weak var playOrPauseBtn: UIButton!

    
    /// 负责更新很多次的timer
    var timer: Timer?
   
    /// 负责 更新歌词 的 屏幕刷新率定时器
    var updateLrcLink: CADisplayLink?
    
    
    //MARK: 移除通知:  在接收通知控制器中移除的，不是在发送通知的类中移除通知的
    deinit { //析构方法中移除
        NotificationCenter.default.removeObserver(self)
    }
 
    // MARK: - 懒加载
    /// 歌词视图控制器
    fileprivate lazy var lrcVC: QQLrcTableVC = {
        let lrcVC = QQLrcTableVC()
        lrcVC.tableView.backgroundColor = .clear
        lrcVC.tableView.frame.origin.x = screenW        // 使得歌词View默认在屏幕之外
        return lrcVC
    }()
    
    // MARK: - 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configUI()
        
        // MARK: 接收通知
        // 通知调用 下一首方法
        NotificationCenter.default.addObserver(self, selector: #selector(nextMusic), name: NSNotification.Name.init(kPlayFinishNotification), object: nil)
        
    }
    
    // 视图即将加入窗口时调用
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UpdateOnce()
        addTimer()
        addLink()
    }
    
    // 视图即将消失、被覆盖或是隐藏时调用
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        removeTimer()
        removeLink()
    }
    
    // MARK: - 按钮点击事件
    /// 关闭按钮点击事件
    @IBAction func closeButton() {
        dismiss(animated: true, completion: nil)
    }
    
    /// 拖动进度条事件
    ///
    /// - Parameter sender: UISlider
    @IBAction func sliderBtn(_ sender: UISlider) {
       
        addTimer()
        
        // 设置歌曲播放某个时间点
        // 0.0 - 1.0
        let value = sender.value
        
        // 获取总时长
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        let totalTime = musicMessageM.totalTime
        
        // 计算已经播放的时长
        let costTime = totalTime * TimeInterval(value)
        
        // 设置歌曲播放到对应的时间点
        QQMusicOperationTool.shareInstance.seekToTime(costTime)
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
}


// MARK: - 自定义方法
extension QQDetailController {
    
    /// 切换歌曲时, 需要更新 1 次的操作
    fileprivate func UpdateOnce() {
        
        // 创建音乐信息模型对象
        let musicMessageModel = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        
        // 校验
        guard let musicM = musicMessageModel.musicM else {return}
        guard musicM.icon != nil else { return }
        
        // 赋值
        backImageView.image = UIImage(named: (musicM.icon)!)
        RoundBackground.image = UIImage(named: (musicM.icon)!)
        songNameLabel.text = musicM.name
        singerNameLabel.text = musicM.singer
        
        // 212.0988 -> 04:56
        totalTimeLabel.text = QQTimeTool.getFormatTime(timeInterval: musicMessageModel.totalTime)
        
        
        // 切换最新的歌词
        let lrcMs = QQMusicDataTool.getLrcModels(lrcName: musicM.lrcname)
        
        lrcVC.lrcModels = lrcMs
        
        addRotationAimation()
        
        if musicMessageModel.isPlaying { // 如果正在播放, 恢复动画
            resumeRotationAnimation()
        }else {                         // 否则 暂停动画
            pauseRotationAnimation()
        }
        
        
    }
    
    
    /// 切换歌曲时, 需要更新 N 次的操作
    @objc private func Update_N_Times() {
        
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        
        // 进度条值 = 已播放时间 / 总时长
        progressSlider.value = Float(musicMessageM.costTime / musicMessageM.totalTime)
        
        /** 已经播放时长 n*/
        costTimeLabel.text = QQTimeTool.getFormatTime(timeInterval: musicMessageM.costTime)
        
        // 播放按钮状态 等于 当前播放状态
        playOrPauseBtn.isSelected = musicMessageM.isPlaying
    }
    
    
    /// 执行多次更新-添加定时器
    fileprivate func addTimer() {
        
        // timeInterval: 时间间隔
        // repeats: 是否重复
        timer = Timer(timeInterval: 1, target: self, selector: #selector(Update_N_Times), userInfo: nil, repeats: true)
        
        // 将定时器加入运行循环
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    /// 移除定时器
    fileprivate func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    
    
    /// 添加屏幕刷新率定时器
    fileprivate func addLink() {
        
        updateLrcLink = CADisplayLink(target: self, selector: #selector(updateLrc))
        
        // 将屏幕刷新率定时器加入运行循环
        updateLrcLink?.add(to: .current, forMode: .commonModes)
        
    }
    /// 移除屏幕刷新率定时器
    fileprivate func removeLink() {
        updateLrcLink?.invalidate()
        updateLrcLink = nil
    }
    
    
    /// 更新歌词
    @objc private func updateLrc() {
        
        // 取出模型
        let musicMessageM = QQMusicOperationTool.shareInstance.getMusicMessageModel()
        
        // 获取歌词
        
        /// 当前时间
        let time = musicMessageM.costTime
        
        // 获取歌词数组
        let lrcMs = lrcVC.lrcModels
        
        let rowLrcModel = QQMusicDataTool.getCurrentLrcM(currentTime: time, lrcModels: lrcMs)
        
        /// 歌词模型
        let lrcModel = rowLrcModel.lrcM
        
        // 赋值
        lrcLabel.text = lrcModel?.lrcContent
        
        //MARK: 设置歌词变色的进度
/*
        lrc格式的歌词文件无法实现根据节奏设置变色进度,这里取平均值:
        每一句歌词在每句歌词显示的总时间内,匀速的变色
        
        因为歌词变色进度也是需要实时更新的,所以也是需要在控制器下的定时器方法内执行的,这里就用到了当当前歌词索引为最后一条时,自定义的一条虚拟歌词对象
*/
        
        guard lrcModel != nil else { return }
        
        // 当前总时间: (下一句的起始时间 - 当前句的 起始时间)
        let time2 = lrcModel!.endTime - lrcModel!.beginTime
        
        // 平均速度进行计算 : (当前播放时间 - 当前句 起始时间) / 当前句总时间
        lrcLabel.radio =  CGFloat((time - lrcModel!.beginTime) / time2)
        
        // 控制器的进度 = 进度Label的进度
        lrcVC.progress = lrcLabel.radio
        
        // 滚动歌词
        // 获取滚到哪一行
        let row = rowLrcModel.row
        
        // 赋值lrcVC, 让它来负责具体怎么滚
        lrcVC.scrollRow = row
        
        
        // 如果处于后台状态, 就设置锁屏信息
        if UIApplication.shared.applicationState == .background {
            // 设置锁屏信息
            QQMusicOperationTool.shareInstance.setUpLookMessage()
        }
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
        
        // 添加 歌词视图控制器 的 表格视图 到 scrollView 中
        scrollView.addSubview(lrcVC.tableView)
        
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
    
    // MARK: 以下都为动画处理
    
    // 当用户拖动 ScrollView 导致 contentOffset 改变的时候就会调用
    /// 目的: 监听滚动视图的滚动, 做透明动画效果
    ///
    /// - Parameter scrollView: 滚动视图
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
    
    /// 添加旋转动画
    fileprivate func addRotationAimation() {
        
        // 防止动画添加多次, 首先移除
        RoundBackground.layer.removeAnimation(forKey: "rotation")
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0                 // 从0开始旋转
        animation.toValue = M_PI * 2            // 旋转360度
        animation.duration = 30                 // 旋转持续的时间
        animation.isRemovedOnCompletion = false // 动画完成后是否删除
        animation.repeatCount = MAXFLOAT        // 无限旋转
        
        // 添加动画
        RoundBackground.layer.add(animation, forKey: "rotation")
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

// MARK: - 用于接收远程事件
extension QQDetailController {
    
    /// 重写远程事件方法接收
    ///
    /// - Parameter event: 事件
    override func remoteControlReceived(with event: UIEvent?) {
        
        /* 事件类型: UIEventType :
                     touches       : 触摸
                     motion        : 手势
                     remoteControl : 远程控制
                     presses       : 按压(3D Touch) 
         */
        
        // subtype: 子类型
        let type = event?.subtype
        
        switch type! {
        case .remoteControlPlay:
            print("播放")
            QQMusicOperationTool.shareInstance.playCurrentMusic()
        case .remoteControlPause:
            print("暂停")
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
        case .remoteControlNextTrack:
            print("下一首")
            QQMusicOperationTool.shareInstance.nextMusic()
        case .remoteControlPreviousTrack:
            print("上一首")
            QQMusicOperationTool.shareInstance.PreviousMusic()
        default:
            print("nono")
        }
        
        UpdateOnce()
        
    }
    
/*
 UIResponder 类中提供了摇一摇: 开始, 取消, 结束 .
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {}
    
    override func motionCancelled(_ motion: UIEventSubtype, with event: UIEvent?) {}
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {}
*/
    
    /// 运动事件(摇一摇开始)
    ///
    /// - Parameters:
    ///   - motion: UI事件类型
    ///   - event: 类型
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
       
        QQMusicOperationTool.shareInstance.nextMusic()
        
        UpdateOnce()
    }
    
    
}
