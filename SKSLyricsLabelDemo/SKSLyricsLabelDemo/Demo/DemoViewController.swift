//
//  ViewController.swift
//  SKSMultiLineLyricsView
//
//  Created by chenzhenchao on 2020/9/25.
//

import UIKit
import SnapKit

class DemoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "多行卡拉OK歌词进度效果"
        self.view.backgroundColor = .white
        self.preInitChildViews()
        self.layoutChildViews()
        self.handleBusiness()
    }
    
    private func preInitChildViews() {
        view.addSubview(oneLineNormalLabel)
        view.addSubview(oneLineAttbuteLabel)
        view.addSubview(mutiLineNormalLabel)
        view.addSubview(mutiLineAttLabel)
    }
    
    private func layoutChildViews() {
        oneLineNormalLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(114)
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(0)
            make.height.greaterThanOrEqualTo(0)
        }
        
        oneLineAttbuteLabel.snp.makeConstraints { (make) in
            make.top.equalTo(oneLineNormalLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.greaterThanOrEqualTo(0)
            make.height.greaterThanOrEqualTo(0)
        }
        
        mutiLineNormalLabel.snp.makeConstraints { (make) in
            make.top.equalTo(oneLineAttbuteLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(mutiLineNormalLabel.textWidth)
            make.height.greaterThanOrEqualTo(0)
        }
        
        mutiLineAttLabel.snp.makeConstraints { (make) in
            make.top.equalTo(mutiLineNormalLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(mutiLineAttLabel.textWidth)
            make.height.greaterThanOrEqualTo(0)
        }
        
    }
    
    private func handleBusiness() {
        // 1、单行普通普通样式
        oneLineNormalLabel.text = "1、点击播放一个单行歌词效果的控件"
        let oneTap1 = UITapGestureRecognizer(target: self, action: #selector(oneNormalLineClick))
        oneLineNormalLabel.addGestureRecognizer(oneTap1)
        
        // 2、单行富文本样式
        let oneAttbute = NSMutableAttributedString()
        oneAttbute.append(NSAttributedString(string: "2、点击播放一个", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]))
        oneAttbute.append(NSAttributedString(string: "单行富文本歌词", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.purple]))
        oneAttbute.append(NSAttributedString(string: "控件", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]))
        oneLineAttbuteLabel.attributeStr = oneAttbute
        
        let oneTap2 = UITapGestureRecognizer(target: self, action: #selector(oneAttbuteLineClick))
        oneLineAttbuteLabel.addGestureRecognizer(oneTap2)
        
        // 3、多行富文本样式
        mutiLineNormalLabel.text = "3、点击播放              一个多行歌词效果      的控件，一波还未平息，一波又来袭击，茫茫人海风潮里去。。。深深太平洋底深深伤心💔"
        let oneTap3 = UITapGestureRecognizer(target: self, action: #selector(mutiNormalClick))
        mutiLineNormalLabel.addGestureRecognizer(oneTap3)
        
        // 4、多行富文本样式
        let mulAttbute = NSMutableAttributedString()
        mulAttbute.append(NSAttributedString(string: "4、点击播放一个", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.black]))
        mulAttbute.append(NSAttributedString(string: "多行富文本歌词", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.brown, .underlineStyle: 1]))
        mulAttbute.append(NSAttributedString(string: "控件换行\r\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 20), .foregroundColor: UIColor.black]))
        mulAttbute.append(NSAttributedString(string: "What's wrong with you,can I help you. What's wrong with you,can I help you", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.systemBlue]))
        mutiLineAttLabel.attributeStr = mulAttbute
        let oneTap4 = UITapGestureRecognizer(target: self, action: #selector(mutiAttbuteClick))
        mutiLineAttLabel.addGestureRecognizer(oneTap4)
    }
    
    lazy var oneLineNormalLabel: SKSOneLineLyricsLabel = {
        let view = SKSOneLineLyricsLabel()
        view.maskColor = .magenta
        view.font = UIFont.systemFont(ofSize: 16)
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var oneLineAttbuteLabel: SKSOneLineLyricsLabel = {
        let view = SKSOneLineLyricsLabel()
        view.maskColor = .magenta
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var mutiLineNormalLabel: SKSMultiLineLyricsLabel = {
        let view = SKSMultiLineLyricsLabel(240)
        view.font = UIFont.boldSystemFont(ofSize: 16)
        view.maskColor = .magenta
        view.backgroundColor = .lightGray
        view.lineSpace = 6
        return view
    }()
    
    lazy var mutiLineAttLabel: SKSMultiLineLyricsLabel = {
        let view = SKSMultiLineLyricsLabel(240)
        view.backgroundColor = .lightGray
        view.textAligment = .center
        return view
    }()

}

// MARK: 🍎🍎🍎 处理事件 🍎🍎🍎
extension DemoViewController {
    @objc func oneNormalLineClick() {
        oneLineNormalLabel.duration = 3.4
    }
    
    @objc func oneAttbuteLineClick() {
        oneLineAttbuteLabel.duration = 3
    }
    
    @objc func mutiNormalClick() {
        self.mutiLineNormalLabel.playAnimation(3) { [weak self] () in
            self?.mutiLineNormalLabel.lineSpace = 0
            self?.mutiLineNormalLabel.textAligment = .right
            self?.mutiLineNormalLabel.font = UIFont.boldSystemFont(ofSize: 18)
        }
    }
    
    @objc func mutiAttbuteClick() {
//        self.mutiLineAttLabel.playAnimation(1) {
//        }
        self.mutiLineAttLabel.duration = 0.8
        self.mutiLineAttLabel.playCompletion = {
            print("播放结束🔚")
        }
    }
    
}
