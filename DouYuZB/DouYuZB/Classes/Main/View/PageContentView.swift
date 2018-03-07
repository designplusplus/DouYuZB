//
//  PageContentView.swift
//  DouYuZB
//
//  Created by Edwin Liang on 2018/3/5.
//  Copyright © 2018年 Edwin Liang. All rights reserved.
//

import UIKit

private var contentCellID = "contentCellID"

protocol PageContentViewDelegate:class {
    func pageContentView(contentView:PageContentView, progress:CGFloat, preIndex:Int, nowIndex:Int)
}

class PageContentView: UIView {

    private var childVCs:[UIViewController]
    private weak var parentVC:UIViewController?
    private var startOffsetX:CGFloat = 0
    weak var delegate:PageContentViewDelegate?
    private var isForbidScrollDelegate:Bool = false
    private lazy var collectionView:UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)! //跟pageContentView一樣大
        layout.minimumLineSpacing = 0 //行距0
        layout.minimumInteritemSpacing = 0 //行距0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false //不顯示水平滾動軸
        collectionView.isPagingEnabled = true //是否以每页的形式进行更换
        collectionView.bounces = false //內容不會超越邊界
        collectionView.delegate = self
        // 增加下面 不然畫面是黑色沒東西
        collectionView.dataSource = self // 須遵守協議
        collectionView.register(UICollectionViewCell.self/*類.self就是取class*/, forCellWithReuseIdentifier: contentCellID)
        return collectionView
    }()
    
    init(frame: CGRect, childVCs:[UIViewController], parentVC:UIViewController?) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageContentView{
    private func setupUI(){
        for childVC in childVCs{
            parentVC?.addChildViewController(childVC)
        }
        
        addSubview(collectionView)
    }
}

extension PageContentView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCellID", for: indexPath)
        //先移除
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        //再新增
        let childVC = childVCs[indexPath.item]
        childVC.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVC.view)
        return cell
    }
}

extension PageContentView{
    func setCurrentIndex(index:Int){
        isForbidScrollDelegate = true
        let offsetX = collectionView.frame.width * CGFloat(index)
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false) // 會觸發scroll事件！！
    }
}

extension PageContentView:UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if isForbidScrollDelegate{return}
        
        var progress:CGFloat = 0 //位移百分比
        var preIndex:Int = 0
        var nowIndex:Int = 0
        let ratio:CGFloat = scrollView.contentOffset.x/scrollView.bounds.width
        if scrollView.contentOffset.x > startOffsetX{ // 左滑
            progress = ratio - floor(ratio) // 取小數
            preIndex = Int(ratio)
            nowIndex = preIndex + 1
            nowIndex = nowIndex >= childVCs.count ? childVCs.count-1 : nowIndex
            // 如果完全滑過去
            if(scrollView.contentOffset.x - startOffsetX == scrollView.bounds.width){
                progress = 1
                nowIndex = preIndex
            }
        }else{ //右滑
            progress = 1-(ratio - floor(ratio)) // 取小數
            nowIndex = Int(ratio)
            preIndex = nowIndex + 1
            preIndex = preIndex >= childVCs.count ? childVCs.count-1 : preIndex
        }
        delegate?.pageContentView(contentView: self, progress: progress, preIndex: preIndex, nowIndex: nowIndex)
    }
}
