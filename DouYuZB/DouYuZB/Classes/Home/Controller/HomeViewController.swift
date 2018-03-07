//
//  HomeViewController.swift
//  DouYuZB
//
//  Created by Edwin Liang on 2018/3/2.
//  Copyright © 2018年 Edwin Liang. All rights reserved.
//

import UIKit

private var kTitleViewH:CGFloat = 40

class HomeViewController: UIViewController {

    private lazy var pageTitleView:PageTitleView = { [weak self] in
        let titleFrame = CGRect(x: 0, y:kStatusBarH+kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推薦","遊戲","娛樂","趣玩"]
        var titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    private lazy var pageContentView:PageContentView = {[weak self] in
        let contentFrame = CGRect(x: 0, y: kStatusBarH+kNavigationBarH+kTitleViewH, width: kScreenW, height: kScreenH-kStatusBarH-kNavigationBarH-kTitleViewH)
        var childVCs = [UIViewController]()
        for _ in 0..<4{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVCs.append(vc)
        }
        var contentView = PageContentView(frame: contentFrame, childVCs: childVCs, parentVC: self)
        contentView.delegate = self
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 設置UI介面
        setupUI()
    }

}

extension HomeViewController{
    
    private func setupUI(){
        setupNavigationBar()
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
    }
 
    private func setupNavigationBar(){
        // 左側
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        // 右側
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }
    
}

// 遵守PageTitleViewDelegate協議
extension HomeViewController:PageTitleViewDelegate{
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(index: index)
    }
}

// 遵守PageContentViewDelegate協議
extension HomeViewController:PageContentViewDelegate{
    func pageContentView(contentView: PageContentView, progress: CGFloat, preIndex: Int, nowIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, preIndex: preIndex, nowIndex: nowIndex)
    }
}

