# SKSLyricsLabel
## ☆☆☆ “iOS卡拉OK歌词效果Label” ☆☆☆

###支持cocoapods导入

    pod 'SKSLyricsLabel', '>= 1.0.3'

---------------------------------------------------------------------------------------------------------------

###更改记录：  
2020.10.15 -- init v1.0.3   动态变化多行控件的最大宽度    
2020.10.15 -- init v1.0.2   修复多行控件反复点击出现的异常    
2020.10.09 -- init v1.0.1   添加一些注释    
2020.09.29 -- init v1.0.0   上传第一版代码    


### 蛮多坑的iOS多行富文本卡拉OK控件，现已实现傻瓜式写法，更多属性可查看源码和demo，记得star哦

    // 最简单的单行普通效果
    let oneLineNormalLabel = SKSOneLineLyricsLabel()
    oneLineNormalLabel.text = "我是一个单行效果的卡拉OK歌词控件文本"
    oneLineNormalLabel.attributeStr = NSAttributedString对象
    oneLineNormalLabel.maskColor = 卡拉OK效果颜色
    self.view.addSubview(oneLineNormalLabel)
    
    oneLineNormalLabel.duration = <#在文本赋值后设置，duration一旦赋值即可实现播放效果#>

---------------------------------------------------------------------------------------------------------------

    // 相对复杂的富文本多行有行间距的效果
    let mutiLineAttLabel = SKSMultiLineLyricsLabel(<#文本控件的最大宽度，为什么不自适应？可见下面的Q&A>)
    mutiLineAttLabel.maskColor = 卡拉OK效果颜色
    mutiLineAttLabel.lineSpace = 行间距
    mutiLineAttLabel.attributeStr = NSAttributedString对象
    self.view.addSubview(mutiLineAttLabel)

    mutiLineAttLabel.playAnimation(<#可以在赋值后播放的时长，完成回调可忽略#>) {
        print("完成播放")
    }

---------------------------------------------------------------------------------------------------------------

![](https://github.com/CoderChan/SKSLyricsLabel/blob/master/DemoScene/demo2.gif)

## Q&A:
### SKSLyricsLabel的思路是什么❓
笔者在这之前花过不少时间尝试其他方案，均不能达到想要的效果。由于目前iOS提供的api还没有可以使用这类效果的（如果有，欢迎联系我635961956，当然单行文本的话就简单得多，但是需求需要兼容多行和富文本）。于是有了将一个超长文本拆分成多行的思路，每一行是一个单行，于是就有了使用CoreText对富文本进行按区域面积拆分的想法，经过一些坑，才有了如今相对稳定的SKSLyricsLabel


### ⏰经典深坑提醒
由于上面的思路，拆分长文本需要一个面积，这个面积需要宽和高，由于高可以根据font.lineHeight设置，但是font.lineHeight在各个机型计算出的浮点型不是完全一样，哪怕只是相差0.000001也会导致面积不够放不下单元格内容，
造成死循环（此坑踩过，已解决）拆分失败，于是将内部的NSAttributedString分类做成了需要传入宽高。附上关键代码：

    /// 对富文本进行平均分割区域
    /// - Parameters:
    ///   - width: 分割单元的宽度
    ///   - height: ⚠️分割单元的高度，请谨慎使用font.lineHeight
    /// - Returns: 分割后的富文本数组
    public func sks_separatedAttLines(width: CGFloat, height: CGFloat) -> [NSAttributedString] {
        let textFrame = CGRect(x: 0, y: 0, width: width, height: height)
        let rectPath: CGPath = CGPath(rect: textFrame, transform: nil)

        var textPos = 0
        let cfAttStr: CFAttributedString = self as CFAttributedString

        let framesetter: CTFramesetter = CTFramesetterCreateWithAttributedString(cfAttStr)
        var pagingResult = [NSAttributedString]()

        while textPos < self.length {
            let frame: CTFrame = CTFramesetterCreateFrame(framesetter, CFRange(location: textPos, length: 0), rectPath, nil)
            let frameRange = CTFrameGetVisibleStringRange(frame)
            if frameRange.length == 0 {
              pagingResult.append(self)
              break
            }

            let range = NSRange(location: frameRange.location, length: frameRange.length)
            let subStr = self.attributedSubstring(from: range)
            pagingResult.append(subStr)
            textPos += frameRange.length
        }

        return pagingResult
    }
   
   ---------------------------------------------------------------------------------------------------------------


