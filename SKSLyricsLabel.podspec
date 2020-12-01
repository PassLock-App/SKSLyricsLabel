#
#  Be sure to run `pod spec lint SKSLyricsLabel.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "SKSLyricsLabel"

  spec.version      = "1.0.3"

  spec.summary      = "类似iOS卡拉OK歌词效果播放进度的Label，支持多行富文本换行。"

  spec.homepage     = "https://github.com/CoderChan/SKSLyricsLabel"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author       = { "陈振超" => "czc1943@126.com" }

  spec.platform     = :ios, "9.0"

  spec.swift_version = "5.0"

  spec.ios.deployment_target = "9.0"

  spec.source       = { :git => "https://github.com/CoderChan/SKSLyricsLabel.git", :tag => spec.version }

  spec.source_files  = "SKSLyricsLabel", "SKSLyricsLabel/*.swift"
  
  spec.frameworks = "UIKit", "Foundation", "QuartzCore"

  spec.requires_arc = true

  spec.dependency "SnapKit"

end
