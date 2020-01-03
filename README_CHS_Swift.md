view [English README for Swift.md](/README_Swift.md)

Email：pikacode@qq.com

微信：pikacode


# EBBannerView

只需一行代码即可：

- App 在前台时展示跟 iOS 9~13 推送通知一样 UI 的横幅，自动根据系统版本显示不同 UI


- 根据手机是否静音自动播放提示音或振动
- 文字较多时自动支持下拉展开样式

并且可以：

- 自定义横幅的图标、标题、时间、内容、动画时间
- 自定义弹出时的声音，可选用系统提示音，或者自己添加声音文件
- 横竖屏自适应


- 完全自定义弹出的 view，自定义 view 在横竖屏时可以定制不同的 frame
- 自定义 view 在横竖屏时支持分别从不同方向弹出（屏幕上下左右中心）
- 监听点击事件、传值




## 效果

### 系统推送通知样式：

  ![](screenshot/1.gif)



### 自定义样式：

  ![](screenshot/2.gif)



## 安装

### pod 安装

```python
use_frameworks!
target 'YourTargetName' do
  pod 'EBBannerViewSwift'
end
```



## 使用



### 系统样式

---

```swift
import EBBannerViewSwift
```



### Demo

[Swift Demo](SwiftDemo)



系统样式有两种使用方式：

#### 方式一：一行代码搞定之省心模式

根据系统不同自动展示 iOS 9~13 的样式，并自动展示 app 名称 图标等。

```swift
EBSystemBanner.show("自定义内容") 
```




#### 方式二：指定不同系统样式，并自定义所有内容

```swift
//1.构造 banner，自定义赋值，没有指定的会使用默认值
let banner = EBSystemBanner()
                  .style(.iOS13)
                  .icon(UIImage(named: "icon"))	
                  .appName("Somebook")
                  .title("title")
                  .content("some content")
                  .date("now")
                  .vibrateOnMute(true)
                  .object(anyObj)	// let anyObj: Any?
                  .sound(.name("sing.mp3"))
                  .onClick { (b) in
                      print(b.title!)
                      print(b.object!)
                  }
//2.展示
banner.show()
```



##### 参数说明 

（以下参数不赋值时均使用默认值）

- `style`：需要展示的样式，默认值 系统类型，可以直接传 `UIDevice.currentDevice.systemVersion.intValue` 来自动适配不同系统，类型 enum : NSInteger {9/10/11}
- `icon`：图片，默认值 app 的图标，类型 UIImage
- `title`：标题，默认值 app 的名称，类型 NSString
- `date`：时间，默认值 NSLocalizedString(@"现在", nil)，类型 NSString
- `content`：内容，类型 NSString
- `showDuration`：显示动画时间，默认值 0.3
- `hideDuration`：隐藏动画时间，默认值 0.5
- `stayDuration`：隐藏之前停留显示的时间，默认值 4，类型 NSTimeInterval
- `spreadStayDuration`：长内容 banner 展开时，hide 之前停留的时间，默认值 4，类型 NSTimeInterval，可以设置一个极大的值使 banner 展开时始终显示，直到用户再次点击 banner 或者手动调用 hide 时才隐藏
- `object`：监听点击事件 `EBBannerViewDidClickNotification` 后可以获取到，见后文，默认值为 `content`，类型 id
- `soundID`：播放的提示音（静音时会自动振动），类型 UInt32
  - 该参数是 iOS 系统自带的声音 id，默认使用的是`三全音`，id = 1312
  - 其他系统声音 id 可以在这里查询到 [iOS Predefined sounds](http://iphonedevwiki.net/index.php/AudioServices#) 备用地址 [AudioServices sounds](http://www.cocoachina.com/bbs/read.php?tid=134344)
  - 可以在这里 [UISounds.zip](/UISounds.zip) 下载并试听全部系统声音，然后选择自己想用的声音，根据名称对照上面提供的表格查找到相应的 `id`
- `soundName`：播放自定义的声音文件，类型 NSString
  - 直接将声音文件拖拽到工程目录
  - 赋值时包含拓展名，例 sound.mp3
- `showDetailOrHideWhenClickLongText`：点击内含长内容的 banner 时是展开所有内容还是收起整个 banner，YES 展开/NO 收起，默认值 YES，类型 BOOL



#### 了解更多详情，请查阅:

- 下载 Swift demo
- 查看源码注释
- 参照 objc 版本的 readme 文档