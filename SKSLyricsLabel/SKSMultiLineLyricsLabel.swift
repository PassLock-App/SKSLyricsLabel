//
//  SKSMultiLineLyricsLabel.swift
//  SKSMultiLineLyricsLabel
//
//  Created by sks on 2020/9/25.
//  Copyright © 2020 chenzhenchao. All rights reserved.
//

import UIKit

/// 多行的歌词效果View
public class SKSMultiLineLyricsLabel: UIView {
    
    /// 一行一行的歌词控件数组
    private (set) lazy var lyricsLabelArray: [SKSOneLineLyricsLabel] = {
        return [SKSOneLineLyricsLabel]()
    }()
        
    /// 文本最大宽度
    public var maxTextWidth: CGFloat = 200 {
        didSet {
            self.updateSubViews()
        }
    }
    
    /// 文本内容
    public var text: String? {
        didSet {
            self.updateSubViews()
        }
    }
    
    /// 字体
    public var font: UIFont = UIFont.systemFont(ofSize: 18) {
        didSet {
            self.updateSubViews()
        }
    }
    
    /// 行间距
    public var lineSpace: CGFloat = 0 {
        didSet {
            self.updateSubViews()
        }
    }
    
    /// 字体颜色
    public var textColor: UIColor = .black {
        didSet {
            self.lyricsLabelArray.forEach { (subView) in
                subView.textColor = textColor
            }
        }
    }
    
    /// 歌词颜色
    public var maskColor: UIColor = UIColor.red {
        didSet {
            self.lyricsLabelArray.forEach { (subView) in
                subView.maskColor = maskColor
            }
        }
    }
    
    /// 对齐方式
    public var textAligment = NSTextAlignment.left {
        didSet {
            self.updateSubViews()
        }
    }
    
    /// 外部设置好的富文本
    public var attributeStr: NSAttributedString? {
        didSet {
            self.updateSubViews()
        }
    }
    
    /// 是否每播放完一行就除移进度色
    public var isRemovedOnCompletion: Bool = true
    
    /// 播放结束的回调
    public var playCompletion: (()->Void)?
    
    /// 播放时长
    public var duration: CGFloat = 0 {
        didSet{
            self.playAnimation(duration)
        }
    }
    
    /// 临时存储器，总时长
    private var sumDuration: CGFloat = 0
    
    /// 当前播放到第几行
    private (set) var playingIndex: Int = 0
    
}

// MARK: 🍎🍎🍎 外部使用 🍎🍎🍎
extension SKSMultiLineLyricsLabel {
    /// 开始播放多行歌词控件
    /// - Parameters:
    ///   - duration: 总播放时长
    ///   - completion: 完成播放的回调
    public func playAnimation(_ duration: CGFloat, completion: (()->Void)? = nil) {
        self.playCompletion = completion
        self.stopAnimation()
        self.playingIndex = 0
        self.sumDuration = duration >= 0 ? duration : -duration
        self.nextLyricsAnimation(duration: self.currentDuration(), index: self.playingIndex) { [weak self] () in
            guard let wSelf = self else { return }
            if wSelf.isRemovedOnCompletion {
                wSelf.stopAnimation()
            }
            wSelf.playCompletion?()
        }
    }
}

// MARK: 🍎🍎🍎 内部实现 🍎🍎🍎
extension SKSMultiLineLyricsLabel {
    
    /// 更新属性后
    private func updateSubViews() {
        
        self.reset()
        
        var attributeArray = [NSAttributedString]()
        if let vAttbuteStr = self.attributeStr {
            // 富文本需要获取富文本中字体最大的那个Font，否则切片不会准确
            attributeArray = vAttbuteStr.sks_separatedAttLines(width: maxTextWidth, height: (vAttbuteStr.sks_maxAttbuteFont() ?? font).lineHeight * 1.5)
        }else{
            let paraStyle = NSMutableParagraphStyle()
            paraStyle.lineSpacing = lineSpace
            paraStyle.alignment = textAligment
            paraStyle.lineBreakMode = .byWordWrapping
            let attributeStr = NSMutableAttributedString(string: text ?? "", attributes: [.font: font, .foregroundColor: textColor, .paragraphStyle: paraStyle])
            attributeArray = attributeStr.sks_separatedAttLines(width: maxTextWidth, height: font.lineHeight * 1.5)
        }
        
        var lastView: UIView?
        for index in 0..<attributeArray.count {
            let subAttbute = attributeArray[index]
            let oneView = SKSOneLineLyricsLabel()
            oneView.isRemovedOnCompletion = false
            oneView.maskColor = maskColor
            oneView.textAligment = textAligment
            oneView.font = font
            oneView.text = subAttbute.string
            oneView.attributeStr = subAttbute
            self.addSubview(oneView)
            unowned  let wSelf = self
            
            oneView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                if let vLastView = lastView {
                    make.top.equalTo(vLastView.snp.bottom).offset(wSelf.lineSpace)
                }else{
                    make.top.equalToSuperview()
                }
                if index == attributeArray.count - 1 {
                    make.bottom.equalToSuperview()
                }else{
                    make.height.greaterThanOrEqualTo(font.lineHeight)
                }
            }
            lastView = oneView
            self.lyricsLabelArray.append(oneView)
        }
    }
    
    /// 停止全部动画
    private func stopAnimation() {
        self.lyricsLabelArray.forEach({ (subView) in
            subView.stopAnimation()
        })
    }
    
    /// 分别计算每一行
    private func nextLyricsAnimation(duration: CGFloat, index: Int, completion: (()->Void)? = nil) {
        guard index < self.lyricsLabelArray.count else {
            completion?()
            return
        }
        
        let view = self.lyricsLabelArray[index]
        view.playAnimation(duration) { [weak self] () in
            guard let wSelf = self else { return }
            wSelf.playingIndex += 1
            let nextDuration: CGFloat = wSelf.currentDuration()
            wSelf.nextLyricsAnimation(duration: nextDuration, index: wSelf.playingIndex, completion: completion)
        }
    }
    
    /// 当前文本的音频长度
    private func currentDuration() -> CGFloat {
        if playingIndex > lyricsLabelArray.count - 1 { return 0 }
        let currentText: String = lyricsLabelArray[playingIndex].text ?? ""
        let currentWidth: CGFloat = currentText.sks_removeSpace().sks_width(font)
        var sumText = ""
        if let vAttbute = self.attributeStr {
            sumText = vAttbute.string
        }else{
            sumText = text ?? ""
        }
        let sumWidth: CGFloat = sumText.sks_removeSpace().sks_width(font)
        if sumWidth == 0 { return 0 }
        
        var progress: CGFloat = currentWidth / sumWidth
        progress = progress > 0 ? progress : 0.1
        progress = progress > 1 ? 1 : progress
        let duration: CGFloat = sumDuration * progress
        return duration
    }
    
    /// 重置状态
    private func reset() {
        self.playingIndex = 0
        self.lyricsLabelArray.forEach({ (subView) in
            subView.stopAnimation()
            subView.removeFromSuperview()
        })
        self.lyricsLabelArray.removeAll()
    }
}
