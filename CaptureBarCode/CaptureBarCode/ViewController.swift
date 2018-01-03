//
//  ViewController.swift
//  CaptureBarCode
//
//  Created by wangyf on 2017/12/23.
//  Copyright © 2017年 wangyf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var captureView = CaptureView()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureView = CaptureView.init(frame: self.view.bounds)
        
        captureView.stopRunning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        captureView.startRunning()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "扫描二维码"
        captureView = CaptureView.init(frame: self.view.bounds)
        self.view.addSubview(captureView)
    }
}


