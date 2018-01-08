//
//  CaptureCollectionViewCell.swift
//  CaptureBarCode
//
//  Created by wangyf on 2018/1/6.
//  Copyright © 2018年 wangyf. All rights reserved.
//

import UIKit

class CaptureCollectionViewCell: UICollectionViewCell {
    var showView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let captureView = CaptureView.init(frame: self.contentView.bounds)
        self.contentView.addSubview(captureView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
