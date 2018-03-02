//
//  MainViewController.swift
//  DouYuZB
//
//  Created by Edwin Liang on 2018/3/2.
//  Copyright © 2018年 Edwin Liang. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVC("Home")
        addChildVC("Live")
        addChildVC("Follow")
        addChildVC("Profile")
    }
    
    private func addChildVC(_ storyBoardName:String){
        // 透過storyboard獲取控制器, 並將childVC作為子控制器
        if let childVC = UIStoryboard(name: storyBoardName, bundle: nil).instantiateInitialViewController() {
            addChildViewController(childVC)
        }
    }
    
}
