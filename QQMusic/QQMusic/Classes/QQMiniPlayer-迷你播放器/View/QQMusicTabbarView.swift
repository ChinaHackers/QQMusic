//
//  QQMusicTabbarView.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/27.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit


// 单元格重用标识符
private let miniCell = "miniCell"


class QQMusicTabbarView: UIView {
    
    // MARK: - 控件属性
    
    /// 集合视图
    @IBOutlet weak var collectionView: UICollectionView!

    /// 播放\暂停
    @IBOutlet weak var playOrPause: UIButton!
    
    /// 歌曲列表
    @IBOutlet weak var songList: UIButton!
    
    /// 模型属性
    fileprivate var musicModels: [QQMusicModel] = [QQMusicModel]() {
        // 监听模型改变
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
             
        configUI()
        
        ExtractData()
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



// MARK: - 配置UI界面
extension QQMusicTabbarView {
    
    
    /// 提供一个通过 Xib 快速创建的类方法
    ///
    /// - Returns: QQMusicTabbarView
    class func Load_QQMusicTabbarView() -> QQMusicTabbarView {
        return Bundle.main.loadNibNamed("QQMusicTabbarView", owner: nil, options: nil)?.first as! QQMusicTabbarView
    }
    
    /// 配置UI界面
    fileprivate func configUI() {
        
        configCollectionView()
        configPlayOrPause()
    }
    
    /// 配置集合视图
    private func configCollectionView() {
        
        // 使得 collectionView 的高度/宽度 随着父控件拉伸而拉伸
//        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // 设置 collectionView 视图滚动范围
//        collectionView.contentSize = CGSize(width: CGFloat(240 * 5), height: tabBarH)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "miniPlayerCell", bundle: nil), forCellWithReuseIdentifier: miniCell)
    }
    
    
    /// 配置播放\暂停按钮
    private func configPlayOrPause() {
        
        playOrPause.lcDrawStaticCircle()
        
        playOrPause.addTarget(self, action: #selector(playOrPauseClicked(_:)), for: .touchUpInside)
        
//        songList.addTarget(self, action: #selector(songListBtnClicked), for: .touchUpInside)

        
        
        
        
    }
}


// MARK: - 监听事件
extension QQMusicTabbarView {
    
//    /// 歌曲列表按钮点击事件
//    @objc fileprivate func songListBtnClicked() {
//
//        print("点击了歌曲列表按钮")
//    }

    /// mini视图 播放\暂停按钮点击事件
    @objc fileprivate func playOrPauseClicked(_ sender: UIButton) {

        sender.isSelected = !sender.isSelected //按钮状态取反

        // 获取cell
        let cell = self.subviews.first?.subviews.first as! miniPlayerCell

        if sender.isSelected { // 播放
            QQMusicOperationTool.shareInstance.playCurrentMusic()
            cell.resumeRotationAnimation()
        }else {                // 暂停
            QQMusicOperationTool.shareInstance.pauseCurrentMusic()
            cell.pauseRotationAnimation()
        }

        
    }
    
    
    
}






// MARK:- 遵守 UICollectionViewDataSource 协议
extension QQMusicTabbarView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 取出模型
        let model = musicModels[indexPath.item]
        
        // 创建cell,并赋值
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: miniCell , for: indexPath) as! miniPlayerCell
        
        cell.qqmusicMo = model
        cell.addRotationAimation()
        return cell
    }
}

// MARK: - 遵守 UICollectionViewDelegate 协议
extension QQMusicTabbarView: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("点击了miniPlayer_ cell")
        
    }
}

// MARK: - 绘制绿色静态圆
extension UIButton {
    
    /// 绘制绿色静态圆
    func lcDrawStaticCircle() {
        
/*
 CAShapeLayer有着几点很重要:
 
    - 它依附于一个给定的path,必须给与path,而且,即使path不完整也会自动首尾相接
    - strokeStart以及strokeEnd代表着在这个path中所占用的百分比
    - CAShapeLayer动画仅仅限于沿着边缘的动画效果,它实现不了填充效果
 
 */
        // 创建一个shapeLayer
        let  StaticCayer = CAShapeLayer()
        StaticCayer.lineWidth = 2                                           // 线条宽度
        StaticCayer.strokeColor = RGBA(58, G: 193, B: 126, A: 1).cgColor    // 边缘线的颜色
        StaticCayer.fillColor =  UIColor.clear.cgColor                      // 闭环填充的颜色
        
        let Staticcenter = CGPoint(x: self.frame.size.width/2, y:  self.frame.size.height/2)
        let Staticradius: CGFloat = 15
        let StaticstartA = CGFloat(0)
        let StaticendA = CGFloat(M_PI_2 * 4)
        
        // 贝塞尔曲线(创建一个圆)
        let Staticpath = UIBezierPath(arcCenter: Staticcenter, radius: Staticradius, startAngle: StaticstartA, endAngle: StaticendA, clockwise: true)
        
        StaticCayer.path = Staticpath.cgPath
        self.layer.addSublayer(StaticCayer)
        
        let DynamicCayer = CAShapeLayer()
        
        //        DynamicCayer.frame = CGRect(x: 0 , y: 0, width: ProgressWH, height: ProgressWH)
        DynamicCayer.lineWidth = 1.5
        
        DynamicCayer.strokeColor = RGBA(58, G: 193, B: 126, A: 1).cgColor
        
        DynamicCayer.fillColor = UIColor.clear.cgColor
        
        
        
        let center = CGPoint(x: self.frame.size.width/2, y:  self.frame.size.height/2)
        
        let radius: CGFloat = 15 - 1.5
        let startA = CGFloat(0)
        let endA = CGFloat(M_PI_2 * 4)
        
        
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startA, endAngle: endA, clockwise: true)
        
        DynamicCayer.path = path.cgPath
        
        // 将layer添加进图层
        self.layer.addSublayer(DynamicCayer)
        
        DynamicCayer.strokeEnd = 0
        
    }
    
}
