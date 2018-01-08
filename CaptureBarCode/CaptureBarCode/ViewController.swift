//
//  ViewController.swift
//  CaptureBarCode
//
//  Created by wangyf on 2017/12/23.
//  Copyright © 2017年 wangyf. All rights reserved.
//

import UIKit

private var topViewHeight : CGFloat = 64.0
private var backViewWidth : CGFloat = kScreenWidth/6
private var scrollViewWidth : CGFloat = kScreenWidth*2/3

class ViewController: UIViewController {
    
//    var captureView = CaptureView()
    
    var topView : UIView = {
        let topView = UIView.init(frame: CGRect.init(x: 0, y: kSatusBarHeight, width: kScreenWidth, height: topViewHeight))
        topView.backgroundColor = UIColor.white
        return topView
    }()
    
    
    var scrollView : UIScrollView = {
        let scrollView = UIScrollView.init(frame: CGRect.init(x: backViewWidth, y: 0, width: scrollViewWidth, height: topViewHeight))
        scrollView.backgroundColor = UIColor.red
        var labelTextArr = ["扫啊扫","AR扫"]
        var i = 0
        for i in 0...(labelTextArr.count - 1)
        {
            let label : UILabel = UILabel.init(frame: CGRect.init(x: (scrollViewWidth/2) * CGFloat(i), y: 0, width: scrollViewWidth/2, height: topViewHeight))
            label.text = labelTextArr[i]
            label.textAlignment = NSTextAlignment.center
            scrollView.addSubview(label)
        }
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: scrollViewWidth/2, height: topViewHeight))
        scrollView.contentSize = CGSize.init(width: (scrollViewWidth/2) * CGFloat(labelTextArr.count), height: topViewHeight)
        return scrollView
    }()
    
    var backView : UIImageView = {
        let backView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: backViewWidth, height: topViewHeight))
        backView.backgroundColor = UIColor.gray
        backView.isUserInteractionEnabled = true
        return backView
    }()
    
    var moreView : UIButton = {
        let moreView = UIButton.init(frame: CGRect.init(x: backViewWidth + scrollViewWidth, y: 0, width: backViewWidth, height: topViewHeight))
        moreView.backgroundColor = UIColor.gray
        moreView.addTarget(self, action: #selector(moreAction), for: UIControlEvents.touchUpInside)
        return moreView
    }()
    
    var collectionView : UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        collectionLayout.itemSize = CGSize.init(width: kScreenWidth, height: kScreenHeight - (kSatusBarHeight + topViewHeight))
        collectionLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        let collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: kSatusBarHeight + topViewHeight,
                                                                      width: kScreenWidth, height: kScreenHeight - (kSatusBarHeight + topViewHeight)),
                                                   collectionViewLayout: collectionLayout)
        collectionView.register(CaptureCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.backgroundColor = UIColor.black
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
}
extension ViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell : CaptureCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CaptureCollectionViewCell
//        cell.showView = CaptureView.init(frame: cell.bounds)
//        return cell
        let cell : CaptureCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CaptureCollectionViewCell
        cell.showView = CaptureView.init(frame: cell.bounds)
        cell.backgroundColor = UIColor.orange
        return cell
    }
    
}


