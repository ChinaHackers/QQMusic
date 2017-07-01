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

class QQListController: UIViewController {
    
    // MARK: - 控件属性
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - 懒加载
    
    /// miniPlayer 视图
    fileprivate lazy var qqMusicTabBar: QQMusicTabbarView = {
        
        let qqMusicTabBar = QQMusicTabbarView.Load_QQMusicTabbarView()
        qqMusicTabBar.frame = CGRect(x: 0, y: screenH - tabBarH, width: screenW, height: screenH - tabBarH)
        qqMusicTabBar.songList.addTarget(self, action: #selector(songListBtnClicked), for: .touchUpInside)
        return qqMusicTabBar
    }()

    
    /// 歌词列表视图
    fileprivate lazy var songLView: songListView = {
        
        let songLView = songListView.Load_songListView()
        songLView.frame = CGRect(x: 0, y: screenH, width: screenW, height: 500)
        songLView.closeBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
       
        // 创建手势
        let top = UITapGestureRecognizer(target: self, action: #selector(BtnSuperViewGesture))
        // 给关闭按钮的 父视图 添加手势
        songLView.closeBtn.superview?.addGestureRecognizer(top)
        return songLView
    }()
    

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
            //print(models)
            
            self.musicModels = models
            QQMusicOperationTool.shareInstance.musicMs = models
        }
    }

    
}


// MARK: - Table view data source \ Table view dele gate
extension QQListController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return musicModels.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 取出模型, 给cell赋值
        let model = musicModels[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! QQMusicCell
        cell.musicM = model
//        cell.aniation(type: .Rotation) // 动画
        return cell
     }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 点击cell闪烁一下
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 取出模型
        let model = musicModels[indexPath.row]
        
        print("正在播放\(model.name)")
        
        QQMusicOperationTool.shareInstance.playMusic(musicM: model)
        
        // 通过storyboard 里面标识符, 跳转控制器
        self.performSegue(withIdentifier: "listToDetail", sender: nil)
    
    }

    //设置cell的显示动画
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //设置cell的显示动画为3d缩放，xy方向的缩放动画，初始值为0.1 结束值为1
        cell.layer.transform  = CATransform3DMakeScale(0.1, 0.1, 1)
        
        UIView.animate(withDuration: 0.25) {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
    }

}

// MARK: - 配置UI界面
extension QQListController {
    
    /// 配置UI界面
    fileprivate func configUI() {
        
        view.addSubview(qqMusicTabBar)
        view.addSubview(songLView)
        configTableView()
        configNavigationBar()
    }
    
    /// 配置导航栏
    private func configNavigationBar() {
        
        // 修改导航栏文字颜色
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    /// 配置UITableView
    private func configTableView() {
        tableView.rowHeight = 60
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundView = UIImageView(image: UIImage(named: "QQListBack.jpg"))
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tabBarH, right: 0)
        tableView.register(UINib(nibName: "QQMusicCell", bundle: nil), forCellReuseIdentifier: identifier)
    }
}

// MARK: - 监听事件
extension QQListController {

    /// 关闭按钮点击事件
    @objc fileprivate func closeBtnClicked() {
        EndAnimation()
    }
    
    /// 歌曲列表按钮点击事件
    @objc fileprivate func songListBtnClicked() {
        StartAnimation()
    }
    
    
    /// 关闭按钮父视图 手势点击事件
    @objc fileprivate func BtnSuperViewGesture() {
        EndAnimation()
    }
 
    /// 开始动画
    fileprivate func StartAnimation() {
        
        UIView.animate(withDuration: 2.0) {
             // miniPlayer 视图y值为:正, 使得向下平移, 从而隐藏
            self.qqMusicTabBar.transform = CGAffineTransform(translationX: 0, y: self.qqMusicTabBar.frame.size.height)
        }
        
        //延时0.5秒执行
        let time: TimeInterval = 0.5
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
            
            UIView.animate(withDuration: 1.0) {
                // 歌曲列表视图 y值为:负, 使得向上平移, 显示 歌曲列表视图
                self.songLView.transform = CGAffineTransform(translationX: 0, y: -self.songLView.frame.size.height)
            }
        }
    }
    
    /// 结束动画
    fileprivate func EndAnimation() {
        
        UIView.animate(withDuration: 0.5) {
            self.songLView.transform = .identity
        }
        
        UIView.animate(withDuration: 1.0) {     // 还原动画
            self.qqMusicTabBar.transform = .identity
        }
        
    }
    
    
    
}
