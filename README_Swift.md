查看中文文档 [中文 Swift README.md](README_CHS_Swift.md)

Email：pikacode@qq.com

微信：pikacode


# EBBannerView

Only one line to show:

- a banner the same style as iOS Push Notifications (auto show iOS 9~13 styles up to system version)
- auto play a sound or vibrate when the banner is showing


- support swipe down gesture for a long text

And more：

- custom banner's icon/title/date/content/animation_time_interval
- custom the sound (use system sound or play a sound file)


- autosize portrait/landscape frame
- show a custom view with different frame in portrait/landscape
- custom view has different animation mode, appear from top/left/right/left/center


- NSNotification with click event and pass a value




## Screenshot

### System style:

  ![](screenshot/3.gif)



### Custom style:

  ![](screenshot/4.gif)



## Installation

### pod

```python
use_frameworks!
target 'YourTargetName' do
  pod 'EBBannerViewSwift', '1.1.3'
end
```



### Demo

[Swift Demo](SwiftDemo)



## Usage


### System style

---

```swift
import EBBannerViewSwift
```

2 ways to use:

#### 1.Fast way to show a iOS style banner with one line

up to system version，will show iOS 9~13 style，auto show app icon/name.

```swift
EBSystemBanner.show("something")
```




#### 2.Customize any property of the banner

```swift
//1.create a banner, custom all values
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
//2.show
banner.show()
```



##### Parameters: 

(if not set will use default values)

- `style`：the iOS style, default is `UIDevice.currentDevice.systemVersion.intValue`, type enum : NSInteger {9/10/11}
- `icon`：the icon, default is app icon, type UIImage
- `title`：the title, default is app name, type NSString
- `date`：the date, default is localized string @"现在" =  @"now", type NSString
- `content`：the content, type NSString
- `showDuration`：the animation time(show the banner), type NSTimeInterval, default is 0.3
- `hideDuration`：the animation time(hide the banner), type NSTimeInterval, default is 0.5
- `stayDuration`：how long the banner will stay before hide, type NSTimeInterval, default is 4.0
- `spreadStayDuration`：how long a long text banner will stay before hide when it is expanded, default is 4.0. U can set it a large value, then the banner will not hide, until customer click it or call 'hide'
- `object`：you can set it when create, then get it when clicked by adding an observer (see below), default is `content`，type id
- `soundID`：the sound will play when the banner is showing (when the mute is turn on iPhone will vibrate), type UInt32
  - it's iOS system sound id, default push notification sound "Tritone" is 1312
  - More sound id to see here [iOS Predefined sounds](http://iphonedevwiki.net/index.php/AudioServices#) or here [AudioServices sounds](http://www.cocoachina.com/bbs/read.php?tid=134344)

  - You can download all the system sounds [UISounds.zip](/UISounds.zip) , listen and choose one which you perfer, then check out it's `id` with the form above
- `soundName`：play a cusome sound file, type NSString
  - drag the file to Xcode proj
  - pass the file name and extension，e.g. `banner.soundName = @"sound.mp3"` 
- `showDetailOrHideWhenClickLongText`： when click a long text banner, expand it for all height or hide it, YES = expand/NO = hide, default is YES



#### Look for more details please:

- download the demo 
- view the comment in source code
- compare with objc readme