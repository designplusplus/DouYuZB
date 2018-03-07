//
//  PageTitleView.swift
//  DouYuZB
//
//  Created by Edwin Liang on 2018/3/3.
//  Copyright © 2018年 Edwin Liang. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate : class { //表示此協議只能被"類"遵守
    func pageTitleView(titleView:PageTitleView, selectedIndex index:Int)
}

private var kScrollLineH:CGFloat=2

class PageTitleView: UIView {
    private var currentTitleIndex:Int = 0
    private var titles:[String]
    weak var delegate:PageTitleViewDelegate? //代理最好用weak
    private var titleNormalColor:(r:CGFloat,g:CGFloat,b:CGFloat) = (85,85,85) // 灰色
    private var titleSelectedColor:(r:CGFloat,g:CGFloat,b:CGFloat) = (255,128,0) // 橘色
    private lazy var titleLabels:[UILabel] = [UILabel]()
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false //不要顯示滾動條
        scrollView.scrollsToTop = false //狀態列觸控左到右滑會讓畫面內容scroll置頂
        scrollView.bounces = false //阻止【橡皮筋回弹】效果
        scrollView.frame = bounds
        return scrollView
    }()
    private lazy var scrollLine:UIView={
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    init(frame: CGRect, titles:[String]) {
        self.titles = titles
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageTitleView{
    private func setupUI(){
        addSubview(scrollView)
        setTitleLabels()
        setButtonLine()
        setScrollLine()
    }
    
    private func setTitleLabels(){
        for (index,title) in titles.enumerated(){
            let label = UILabel()
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: titleNormalColor.r, g: titleNormalColor.g, b: titleNormalColor.b)
            label.textAlignment = .center
            let labelW:CGFloat = frame.width / CGFloat(titles.count)
            let labelH:CGFloat = frame.height - kScrollLineH
            let labelX:CGFloat = labelW * CGFloat(index)
            let labelY:CGFloat = 0
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            label.isUserInteractionEnabled = true //可以點擊
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGesture:)))
            label.addGestureRecognizer(tapGesture)
        }
    }
    
    private func setButtonLine(){
        let buttonLine = UIView()
        buttonLine.backgroundColor = UIColor.lightGray
        let lineH:CGFloat = 0.5
        buttonLine.frame = CGRect(x: 0, y: frame.height-lineH, width: frame.width, height: lineH)
        addSubview(buttonLine)
    }
    
    private func setScrollLine(){
        guard let firstLabel = titleLabels.first else {return}
        firstLabel.textColor = UIColor(r: titleSelectedColor.r, g: titleSelectedColor.g, b: titleSelectedColor.b)
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height-kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
    }
}

extension PageTitleView{
    @objc private func titleLabelClick(tapGesture:UIGestureRecognizer){
        guard let currentLabel = tapGesture.view as? UILabel else {return}
        currentLabel.textColor = UIColor(r: titleSelectedColor.r, g: titleSelectedColor.g, b: titleSelectedColor.b)
        let oldLabel = titleLabels[currentTitleIndex]
        oldLabel.textColor = UIColor(r: titleNormalColor.r, g: titleNormalColor.g, b: titleNormalColor.b)
        currentTitleIndex = currentLabel.tag
        // 移動 scrollLine
        let scrollLineX = CGFloat(currentTitleIndex) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15, animations: {self.scrollLine.frame.origin.x = scrollLineX})
        // 通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentTitleIndex)
    }
}

extension PageTitleView{
    func setTitleWithProgress(progress:CGFloat, preIndex:Int, nowIndex:Int){
        let preLabel = titleLabels[preIndex]
        let nowLabel = titleLabels[nowIndex]
        let moveTotalX = nowLabel.frame.origin.x - preLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = preLabel.frame.origin.x + moveX
        
        let colorDelta = (titleSelectedColor.r-titleNormalColor.r,titleSelectedColor.g-titleNormalColor.g,titleSelectedColor.b-titleNormalColor.b)
        preLabel.textColor = UIColor(r: titleSelectedColor.r-colorDelta.0*progress, g: titleSelectedColor.g-colorDelta.1*progress, b: titleSelectedColor.b-colorDelta.2*progress)
        nowLabel.textColor = UIColor(r: titleNormalColor.r+colorDelta.0*progress, g: titleNormalColor.g+colorDelta.1*progress, b: titleNormalColor.b+colorDelta.2*progress)
        
        currentTitleIndex = nowIndex
    }
}
