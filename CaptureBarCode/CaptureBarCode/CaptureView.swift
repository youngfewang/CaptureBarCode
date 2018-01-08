//
//  CaptureView.swift
//  CaptureBarCode
//
//  Created by wangyf on 2018/1/3.
//  Copyright © 2018年 wangyf. All rights reserved.
//

import UIKit
import AVFoundation

/// 屏幕宽度
let kScreenWidth = UIScreen.main.bounds.size.width

/// 屏幕高度
let kScreenHeight = UIScreen.main.bounds.size.height

/// 导航条高度
let kSatusBarHeight = UIApplication.shared.statusBarFrame.height

/// 中间扫描框的高度
private let kBoxW : CGFloat = kScreenWidth * 0.7

/// 中间扫描框的中间点的Y
private let kBoxCentY : CGFloat = kScreenHeight * 0.4

//中间扫描框的四个顶点
private let leftTopPoint = CGPoint.init(x: (kScreenWidth - kBoxW)/2, y: (kBoxCentY - (kBoxW/2)))
private let rightTopPoint = CGPoint.init(x: (kScreenWidth + kBoxW)/2, y: (kBoxCentY - (kBoxW/2)))
private let rightBottomPoint = CGPoint.init(x: (kScreenWidth + kBoxW)/2, y: (kBoxCentY + (kBoxW/2)))
private let leftBottomPoint = CGPoint.init(x: (kScreenWidth - kBoxW)/2, y: (kBoxCentY + (kBoxW/2)))

class CaptureView: UIView {

    
    /// 扫描会话
    var session = AVCaptureSession()
    
    /// 预览图层
    lazy var preview : AVCaptureVideoPreviewLayer = {
        let preview = AVCaptureVideoPreviewLayer.init(session: self.session)
        preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
        preview.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height:kScreenHeight)
        preview.backgroundColor = UIColor.black.cgColor
        
        
        let bpath : UIBezierPath = UIBezierPath.init(rect: self.bounds)
        let path = self.createBezierPath(points: [leftTopPoint,rightTopPoint,rightBottomPoint,leftBottomPoint])
        bpath.append(path)
        let shaplayer = CAShapeLayer()
        shaplayer.frame = preview.bounds
        shaplayer.path = bpath.cgPath
        shaplayer.fillColor = UIColor.black.withAlphaComponent(0.4).cgColor
        shaplayer.fillRule = kCAFillRuleEvenOdd
        
        // 绘画折角参数
        let edgeWidth : CGFloat = 30
        let edgeSize = CGSize.init(width: edgeWidth, height: edgeWidth)
        let edgeLineWidth_broken : CGFloat = 2
        // 绘画直线参数
        let edgeWidthLine : CGFloat = kBoxW - edgeWidth * 2
        let edgeLineWidth_straight : CGFloat = 0.5
        let edgeSize_Line = CGSize.init(width: edgeWidthLine, height: edgeLineWidth_straight)
        
        // 左上角折角
        let leftTopLayer = CAShapeLayer()
        leftTopLayer.frame = CGRect.init(origin: leftTopPoint, size: edgeSize)
        let leftTopPath = self.createBezierPath(points: [CGPoint.init(x: 0, y: 0),
                                                         CGPoint.init(x: edgeWidth, y: 0),
                                                         CGPoint.init(x: edgeWidth, y: edgeLineWidth_broken),
                                                         CGPoint.init(x: edgeLineWidth_broken, y: edgeLineWidth_broken),
                                                         CGPoint.init(x: edgeLineWidth_broken, y: edgeWidth),
                                                         CGPoint.init(x: 0, y: edgeWidth)])
        leftTopLayer.path = leftTopPath.cgPath
        leftTopLayer.fillColor = UIColor.init(hexString: "#00abf3").cgColor
        
        // 上方直线
        let TopLayer_Line = CAShapeLayer()
        TopLayer_Line.frame = CGRect.init(origin: CGPoint.init(x: (leftTopPoint.x + edgeWidth), y: leftTopPoint.y), size: edgeSize_Line)
        let TopPath_Line = self.createBezierPath(points: [CGPoint.init(x: 0, y: (edgeLineWidth_broken - edgeLineWidth_straight)/2),
                                                          CGPoint.init(x: edgeWidthLine, y: (edgeLineWidth_broken - edgeLineWidth_straight)/2),
                                                          CGPoint.init(x: edgeWidthLine, y: edgeLineWidth_straight + (edgeLineWidth_broken - edgeLineWidth_straight)/2),
                                                          CGPoint.init(x: 0, y: edgeLineWidth_straight + (edgeLineWidth_broken - edgeLineWidth_straight)/2)])
        TopLayer_Line.path = TopPath_Line.cgPath
        TopLayer_Line.fillColor = UIColor.gray.cgColor
        
        // 右上角折角
        let rightTopLayer = CAShapeLayer()
        rightTopLayer.frame = CGRect.init(origin: CGPoint.init(x: rightTopPoint.x - edgeWidth, y: rightTopPoint.y), size: edgeSize)
        let rightTopPath = self.createBezierPath(points: [CGPoint.init(x: edgeWidth, y: 0),
                                                          CGPoint.init(x: 0, y: 0),
                                                          CGPoint.init(x: 0, y: edgeLineWidth_broken),
                                                          CGPoint.init(x: edgeWidth - edgeLineWidth_broken, y: edgeLineWidth_broken),
                                                          CGPoint.init(x: edgeWidth - edgeLineWidth_broken, y: edgeWidth),
                                                          CGPoint.init(x: edgeWidth, y: edgeWidth)])
        rightTopLayer.path = rightTopPath.cgPath
        rightTopLayer.fillColor = UIColor.init(hexString: "#00abf3").cgColor
        
        // 右方直线
        let rightLayer_Line = CAShapeLayer()
        rightLayer_Line.frame = CGRect.init(origin: CGPoint.init(x: (rightTopPoint.x) - edgeLineWidth_broken, y: rightTopPoint.y + edgeWidth), size: edgeSize_Line)
        let rightPath_Line = self.createBezierPath(points: [CGPoint.init(x: (edgeLineWidth_broken - edgeLineWidth_straight)/2, y: 0),
                                                            CGPoint.init(x: (edgeLineWidth_broken - edgeLineWidth_straight)/2, y: edgeWidthLine),
                                                            CGPoint.init(x: edgeLineWidth_straight + (edgeLineWidth_broken - edgeLineWidth_straight)/2, y: edgeWidthLine),
                                                            CGPoint.init(x: edgeLineWidth_straight + (edgeLineWidth_broken - edgeLineWidth_straight)/2, y: 0)])
        rightLayer_Line.path = rightPath_Line.cgPath
        rightLayer_Line.fillColor = UIColor.gray.cgColor
        
        // 右下角折角
        let rightBottomLayer = CAShapeLayer()
        rightBottomLayer.frame = CGRect.init(origin: CGPoint.init(x: rightBottomPoint.x - edgeWidth, y: rightBottomPoint.y - edgeWidth), size: edgeSize)
        let rightBottomPath = self.createBezierPath(points: [CGPoint.init(x: edgeWidth, y: edgeWidth),CGPoint.init(x: edgeWidth, y: 0),CGPoint.init(x: edgeWidth - edgeLineWidth_broken, y: 0),CGPoint.init(x: edgeWidth - edgeLineWidth_broken, y: edgeWidth - edgeLineWidth_broken),CGPoint.init(x: 0, y: edgeWidth - edgeLineWidth_broken),CGPoint.init(x: 0, y: edgeWidth)])
        rightBottomLayer.path = rightBottomPath.cgPath
        rightBottomLayer.fillColor = UIColor.init(hexString: "#00abf3").cgColor
        
        // 下方直线
        let bottomLayer_Line = CAShapeLayer()
        bottomLayer_Line.frame = CGRect.init(origin: CGPoint.init(x: (leftBottomPoint.x + edgeWidth), y: leftBottomPoint.y - edgeLineWidth_broken), size: edgeSize_Line)
        let bottomPath_Line = self.createBezierPath(points: [CGPoint.init(x: 0, y: (edgeLineWidth_broken - edgeLineWidth_straight)/2),
                                                             CGPoint.init(x: edgeWidthLine, y: (edgeLineWidth_broken - edgeLineWidth_straight)/2),
                                                             CGPoint.init(x: edgeWidthLine, y: edgeLineWidth_straight + (edgeLineWidth_broken - edgeLineWidth_straight)/2),
                                                             CGPoint.init(x: 0, y: edgeLineWidth_straight + (edgeLineWidth_broken - edgeLineWidth_straight)/2)])
        bottomLayer_Line.path = bottomPath_Line.cgPath
        bottomLayer_Line.fillColor = UIColor.gray.cgColor
        
        // 左下角折角
        let leftBottomLayer = CAShapeLayer()
        leftBottomLayer.frame = CGRect.init(origin: CGPoint.init(x: leftBottomPoint.x, y: leftBottomPoint.y - edgeWidth), size: edgeSize)
        let leftBottomPath = self.createBezierPath(points: [CGPoint.init(x: 0, y: edgeWidth),CGPoint.init(x: edgeWidth, y: edgeWidth),CGPoint.init(x: edgeWidth, y: edgeWidth - edgeLineWidth_broken),CGPoint.init(x: edgeLineWidth_broken, y: edgeWidth - edgeLineWidth_broken),CGPoint.init(x: edgeLineWidth_broken, y: 0),CGPoint.init(x: 0, y: 0)])
        leftBottomLayer.path = leftBottomPath.cgPath
        leftBottomLayer.fillColor = UIColor.init(hexString: "#00abf3").cgColor
        
        // 左方直线
        let leftLayer_Line = CAShapeLayer()
        leftLayer_Line.frame = CGRect.init(origin: CGPoint.init(x: (leftTopPoint.x), y: leftTopPoint.y + edgeWidth), size: edgeSize_Line)
        let leftPath_Line = self.createBezierPath(points: [CGPoint.init(x: (edgeLineWidth_broken - edgeLineWidth_straight)/2, y: 0),
                                                           CGPoint.init(x: (edgeLineWidth_broken - edgeLineWidth_straight)/2, y: edgeWidthLine),
                                                           CGPoint.init(x: edgeLineWidth_straight + (edgeLineWidth_broken - edgeLineWidth_straight)/2, y: edgeWidthLine),
                                                           CGPoint.init(x: edgeLineWidth_straight + (edgeLineWidth_broken - edgeLineWidth_straight)/2, y: 0)])
        leftLayer_Line.path = leftPath_Line.cgPath
        leftLayer_Line.fillColor = UIColor.gray.cgColor
        
        
        preview.addSublayer(shaplayer)
        preview.addSublayer(leftTopLayer)
        preview.addSublayer(TopLayer_Line)
        preview.addSublayer(rightTopLayer)
        preview.addSublayer(rightLayer_Line)
        preview.addSublayer(rightBottomLayer)
        preview.addSublayer(bottomLayer_Line)
        preview.addSublayer(leftBottomLayer)
        preview.addSublayer(leftLayer_Line)
        
        
        return preview
    }()
    
    lazy var animalLine : UIImageView = {
        
        let line = UIImageView.init(image: UIImage.init(named: "zxing_laser.png"))
        
        self.addSubview(line)
        
        return line
    }()
    
    var isAnimal : Bool?
    
    var prompt : UILabel = {
        let prompt = UILabel.init(frame: CGRect.init(x: leftBottomPoint.x, y: leftBottomPoint.y + 10, width: kBoxW, height: 60))
        prompt.text = "将二维码放入扫描框即可自动扫描"
        prompt.textAlignment = .center
        prompt.font = UIFont.systemFont(ofSize: 15)
        prompt.textColor = UIColor.white
        prompt.numberOfLines = 0
        
        return prompt
    }()
    var timer : Timer?

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        /// 获取设备
        let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        let videoInput: AVCaptureDeviceInput
        
        do {
            // 视频输入
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice!)
        } catch {
            return
        }
        
        
        // 视频输出
        let videoOutput = AVCaptureMetadataOutput()
        videoOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        }
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        ///扫描类型
        videoOutput.metadataObjectTypes = [
            .qr,
            .code39,
            .code128,
            .code39Mod43,
            .ean13,
            .ean8,
            .code93]
        ///可识别区域  注意看这个rectOfInterest  不是一左上角为原点，以右上角为原点 并且rect的值是个比例在【0，1】之间
        videoOutput.rectOfInterest = CGRect.init(x: (kBoxCentY - (kBoxW/2) )/kScreenHeight,
                                                 y: 1 - (kScreenWidth + kBoxW)/2/kScreenWidth,
                                                 width: kBoxW/kScreenHeight,
                                                 height: kBoxW/kScreenWidth)
        
        
        self.layer.addSublayer(preview)
        self.addSubview(prompt)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createBezierPath( points : [CGPoint]) -> UIBezierPath {
        
        var points = points
        let path = UIBezierPath()
        
        path.move(to: points.first!)
        
        points.remove(at: 0)
        
        for point in points {
            
            path.addLine(to: point)
        }
        
        path.close()
        
        return path
    }
    
    
    /// 开始扫描
    public func startRunning() {
        session.startRunning()
        setupTimer()
    }
    
    @objc func animalStart() {
        self.bringSubview(toFront: self.animalLine)
        animalLine.frame = CGRect.init(x: leftTopPoint.x, y: leftTopPoint.y , width: kBoxW, height: 1)
        UIView.animate(withDuration: 3, animations: {
            let frame = self.animalLine.frame
            let newY : CGFloat = leftTopPoint.y + kBoxW - frame.size.height
            let newFrame = CGRect.init(x: frame.origin.x, y: newY, width: frame.size.width, height: frame.size.height)
            self.animalLine.frame = newFrame
        }) { (finish) in
            
        }
    }
    
    /// 结束扫描
    public func stopRunning()  {
        session.stopRunning()
        timer?.invalidate()
    }
    
    func setupTimer()  {
        self.animalStart()
        self.timer = Timer.init(timeInterval: 3, target: self, selector: #selector(animalStart), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
    
    
    deinit {
        print("dealloc")
    }
 

}
extension CaptureView : AVCaptureMetadataOutputObjectsDelegate
{
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        //扫描结果
        print(output)
        
        if metadataObjects.count > 0  {
            
            let obj : AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            
            let str : String = obj.stringValue!
            
            prompt.text = str
            stopRunning()
            
            startRunning()
        }
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
