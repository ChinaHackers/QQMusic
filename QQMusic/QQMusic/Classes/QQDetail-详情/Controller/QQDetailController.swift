//
//  QQDetailController.swift
//  QQMusic
//
//  Created by Liu Chuan on 2017/6/24.
//  Copyright © 2017年 LC. All rights reserved.
//

import UIKit

class QQDetailController: UIViewController {

    
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
    }
}
