//
//  SKSOneLineLyricsLabel.swift
//  SKSOneLineLyricsLabel
//
//  Created by chenzhenchao on 2020/9/25.
//  Copyright © 2020 chenzhenchao. All rights reserved.
//

import Foundation
import SnapKit
import QuartzCore

/// 单行的歌词效果View
public class SKSOneLineLyricsLabel : UIView {
    
    // MARK: 🍎🍎🍎 开始绘制 🍎🍎🍎
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.preInitChildViews()
        self.layoutChildViews()
        self.handleBusiness()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopAnimation()
    }
    
    private func preInitChildViews() {
        addSubview(textLabel)
        addSubview(maskLabel)
        maskLabel.layer.mask = maskLayer
    }
    
    private func layoutChildViews() {
        textLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        maskLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func handleBusiness() {
      
    }
    
    public override func layoutSubviews() {
      super.layoutSubviews()
      maskLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
      maskLayer.position = CGPoint(x: 0, y: self.bounds.height / 2.0)
      maskLayer.bounds = CGRect(x: 0, y: 0, width: 0, height: self.bounds.height)
      maskLayer.backgroundColor = UIColor.red.cgColor
    }
    
    // MARK: 🍎🍎🍎 懒加载 🍎🍎🍎
    
    /// 用来控制maskLabel渲染的layer
    private lazy var maskLayer: CALayer = {
        return CALayer()
    }()
    
    /// 文本
    private lazy var textLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    /// 镂空层
    private lazy var maskLabel: UILabel = {
        let view = UILabel()
        view.textColor = maskColor ?? UIColor.red
        return view
    }()
    
    // MARK: 🍎🍎🍎 GET && SET 🍎🍎🍎
    /// 播放完之后是否remove歌词效果
    public var isRemovedOnCompletion: Bool = true
    
    /// 播放结束的回调
    public var playCompletion: (()->Void)?
    
    /// 字体
    public var font: UIFont? {
        didSet {
            self.textLabel.font = font
            self.maskLabel.font = font
        }
    }
    
    /// 文本
    public var text: String? {
        didSet {
            self.textLabel.text = text
            self.maskLabel.text = text
        }
    }
    
    /// 富文本，mask不存在富文本样式
    public var attributeStr: NSAttributedString? {
        didSet {
            self.text = attributeStr?.string
            self.textLabel.attributedText = attributeStr
            self.maskLabel.font = self.textLabel.font
        }
    }
    
    /// TEXT颜色
    public var textColor: UIColor? {
        didSet {
            self.textLabel.textColor = textColor
        }
    }
    
    /// MASK颜色
    public var maskColor: UIColor? {
        didSet {
            self.maskLabel.textColor = maskColor
        }
    }
    
    /// 对齐方式
    open var textAligment: NSTextAlignment? {
        didSet {
            self.textLabel.textAlignment = textAligment ?? .left
            self.maskLabel.textAlignment = textAligment ?? .left
        }
    }
    
    /// 播放时长
    public var duration: CGFloat = 0 {
        didSet {
            self.playAnimation(duration)
        }
    }
    
}

// MARK: 🍎🍎🍎 播放进度处理 🍎🍎🍎
extension SKSOneLineLyricsLabel : CAAnimationDelegate {
    /// 播放完毕的代理
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            self.playCompletion?()
        }
    }
    
    /// 根据设置显示动画
    /// 开始播放多行歌词控件
    /// - Parameters:
    ///   - duration: 总播放时长
    ///   - completion: 完成播放的回调
    public func playAnimation(_ duration: CGFloat, completion: (()->Void)? = nil) {
        
        self.playCompletion = completion
        self.stopAnimation()
        guard self.bounds.width > 0, duration > 0 else {
            self.playCompletion?()
            return
        }
        
        let timeArray: Array<CGFloat> = [0, duration]
        let locationArray: Array<CGFloat> = [0, 1]
        var keyTimeArray = [CGFloat]()
        var widthArray = [CGFloat]()
        for i in 0..<timeArray.count {
          let tempTime = timeArray[i] / duration
          let tempWidth = locationArray[i] * self.bounds.width
          keyTimeArray.append(tempTime)
          widthArray.append(tempWidth)
        }
        
        let keyaAnimation = CAKeyframeAnimation(keyPath: "bounds.size.width")
        keyaAnimation.values = widthArray
        keyaAnimation.keyTimes = keyTimeArray as [NSNumber]
        keyaAnimation.duration = CFTimeInterval(duration)
        keyaAnimation.calculationMode = CAAnimationCalculationMode.linear
        keyaAnimation.fillMode = CAMediaTimingFillMode.forwards
        keyaAnimation.isRemovedOnCompletion = isRemovedOnCompletion
        keyaAnimation.delegate = self
        self.maskLayer.add(keyaAnimation, forKey: "sks_lyrcis_anim")
    }
    
    /// 停止动画
    public func stopAnimation() {
        self.maskLayer.removeAllAnimations()
    }
}

