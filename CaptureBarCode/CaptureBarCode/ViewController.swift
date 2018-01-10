//
//  ViewController.swift
//  CaptureBarCode
//
//  Created by wangyf on 2017/12/23.
//  Copyright © 2017年 wangyf. All rights reserved.
//

import UIKit

private var topViewHeight : CGFloat = 50.0
private var backViewWidth : CGFloat = kScreenWidth/6
private var scrollViewWidth : CGFloat = kScreenWidth*2/3
private var underLineHeight : CGFloat = 3.0
private var scrollLabelWidth : CGFloat = scrollViewWidth/3

class ViewController: UIViewController {
    
    var labelTextArr = ["扫啊扫","AR扫","更多扫描"]
    
    var topView : UIView = {
        let topView = UIView.init(frame: CGRect.init(x: 0, y: kSatusBarHeight, width: kScreenWidth, height: topViewHeight))
        topView.backgroundColor = UIColor.black
        return topView
    }()
    
    lazy var underLine : UIView = {
        let underLine = UIView.init(frame: CGRect.init(x: 0, y: topViewHeight - underLineHeight, width: scrollLabelWidth, height: underLineHeight))
        underLine.backgroundColor = UIColor.init(hexString: "#00abf3")
        return underLine
    }()
    
    var scrollView : UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: backViewWidth, y: 0, width: scrollViewWidth, height: topViewHeight))
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    var backView : UIImageView = {
        let backView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: backViewWidth, height: topViewHeight))
        backView.image = UIImage.init(named: "nav_back.png")
        backView.contentMode = UIViewContentMode.left
        backView.isUserInteractionEnabled = true
        return backView
    }()
    
    var moreView : UIButton = {
        let moreView = UIButton.init(frame: CGRect.init(x: backViewWidth + scrollViewWidth, y: 0, width: backViewWidth, height: topViewHeight))
        moreView.setImage(UIImage.init(named: "more.png"), for:UIControlState.normal)
        moreView.addTarget(self, action: #selector(moreAction), for: UIControlEvents.touchUpInside)
        return moreView
    }()
    
    lazy var collectionView : UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionLayout.itemSize = CGSize.init(width: kScreenWidth, height: kScreenHeight - (kSatusBarHeight + topViewHeight))
        collectionLayout.minimumInteritemSpacing = 0.0
        collectionLayout.minimumLineSpacing = 0.0
        collectionLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: kSatusBarHeight + topViewHeight,
                                                                      width: kScreenWidth, height: kScreenHeight - (kSatusBarHeight + topViewHeight)),
                                                   collectionViewLayout: collectionLayout)
        collectionView.register(CaptureCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    @objc func backAction(sender:UITapGestureRecognizer) -> Void {
        print("Back View")
    }
    
    @objc func moreAction() -> Void {
        print("More Button")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        captureView.stopRunning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        captureView.startRunning()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "扫描二维码"
//        captureView = CaptureView.init(frame: self.view.bounds)
//        self.view.addSubview(captureView)
        self.setScrollLabels()
        self.setScrollUnderLine()
        topView.addSubview(scrollView)
        
        let tapGes = UITapGestureRecognizer.init(target:self, action: #selector(backAction(sender:)))
        backView.addGestureRecognizer(tapGes)
        topView.addSubview(backView)
        topView.addSubview(moreView)
        self.view.addSubview(topView)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
    }
    
    func setScrollLabels() -> Void {
        for i in 0...(labelTextArr.count - 1)
        {
            let label : UILabel = UILabel.init(frame: CGRect.init(x: scrollLabelWidth * CGFloat(i), y: 0, width: scrollLabelWidth, height: topViewHeight - underLineHeight))
            label.text = labelTextArr[i]
            label.textAlignment = NSTextAlignment.center
            label.tag = i
            label.textColor = UIColor.white
            label.isUserInteractionEnabled = true
            let tapGesLabel = UITapGestureRecognizer.init(target: self, action: #selector(scrollLabelClick(sender:)))
            label.addGestureRecognizer(tapGesLabel)
            scrollView.addSubview(label)
        }
        scrollView.contentSize = CGSize.init(width: scrollLabelWidth * CGFloat(labelTextArr.count), height: topViewHeight)
    }
    
    @objc func scrollLabelClick(sender: UITapGestureRecognizer) -> Void {
        let scrollLabel : UILabel = sender.view as! UILabel
        collectionView.setContentOffset(CGPoint.init(x: CGFloat(scrollLabel.tag) * kScreenWidth, y: 0), animated: true)
        self.scrollViewDidEndScrollingAnimation(collectionView)
    }
    
    func setScrollUnderLine() -> Void {
        let showLabel : UILabel = self.getScrollLabels()[0]
        underLine.center.x = showLabel.center.x
        scrollView.addSubview(underLine)
    }
    
    func getScrollLabels() -> [UILabel] {
        var scrollLabelArr = [UILabel]()
        for view : UIView in scrollView.subviews {
            if view.isKind(of: UILabel.self) {
                scrollLabelArr.append(view as! UILabel)
            }
        }
        return scrollLabelArr
    }
}
extension ViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelTextArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : CaptureCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CaptureCollectionViewCell
        cell.showView = CaptureView.init(frame: cell.bounds)
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (scrollView.isEqual(collectionView)) {
            self.scrollViewDidEndScrollingAnimation(scrollView)
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let indexScroll : UInt = UInt(scrollView.contentOffset.x / kScreenWidth)
        let showLabel : UILabel = self.getScrollLabels()[Int(indexScroll)]
        UIView.animate(withDuration: 0.5, animations: {
            self.underLine.center.x = showLabel.center.x
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value : CGFloat = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (value < 0) {return;} // 防止在最左侧的时候，再滑，下划线位置会偏移，颜色渐变会混乱。
        
        let leftIndex : UInt = UInt(value);
        var rightIndex : UInt = leftIndex + 1;
        if (rightIndex >= self.getScrollLabels().count) {  // 防止滑到最右，再滑，数组越界，从而崩溃
            rightIndex = UInt(self.getScrollLabels().count - 1);
        }
        
        let scaleRight : CGFloat = value - CGFloat(leftIndex);
        let scaleLeft : CGFloat  = 1 - scaleRight;
        
        let labelLeft : UILabel  = self.getScrollLabels()[Int(leftIndex)];
        let labelRight : UILabel = self.getScrollLabels()[Int(rightIndex)];
        
        // 点击label会调用此方法1次，会导致【scrollViewDidEndScrollingAnimation】方法中的动画失效，这时直接return。
        if (scaleLeft == 1 && scaleRight == 0) {
            return;
        }
        
        underLine.center.x = labelLeft.center.x   + (labelRight.center.x   - labelLeft.center.x)   * scaleRight;
    }
    
}
extension UIColor{
    convenience init(hexString:String){
        //处理数值
        var cString = hexString.uppercased().trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let length = (cString as NSString).length
        //错误处理
        if (length < 6 || length > 7 || (!cString.hasPrefix("#") && length == 7)){
            //返回whiteColor
            self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
            return
        }
        
        if cString.hasPrefix("#"){
            cString = (cString as NSString).substring(from: 1)
        }
        
        //字符chuan截取
        var range = NSRange()
        range.location = 0
        range.length = 2
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        //存储转换后的数值
        var r:UInt32 = 0,g:UInt32 = 0,b:UInt32 = 0
        //进行转换
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        //根据颜色值创建UIColor
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
}



