//
//  AppDelegate.swift
//  DouYuZB
//
//  Created by Edwin Liang on 2018/3/2.
//  Copyright © 2018年 Edwin Liang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITabBar.appearance().tintColor = UIColor.orange
        return true
    }
    
}

