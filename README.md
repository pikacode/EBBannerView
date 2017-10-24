查看中文文档 [Chinese README.md](/README_CHS.md)

Email：pikacode@qq.com

QQ群: 345192153

# EBBannerView

Only one line to show:

- a banner the same style with iOS Push Notifications (auto show iOS 9/10/11 styles up to system version)
- auto play a sound or vibrate when the banner is showing


- iOS 9 style support swipe down gesture for a long text

And more：

- custom banner's icon/title/date/content/animation_time_interval
- custom the sound (use system sound or play a sound file)


- autosize portrait/landscape frame
- show a custom view with different frame in portrait/landscape


- NSNotification with click event and pass a value
- support simulator





## Screenshot

  ![](https://github.com/pikacode/EBBannerView/screenshot/screenshot02.gif)



## Installation

### pod

	target 'YourTargetName' do
	  pod 'EBBannerView'
	end




## Usage
```objc
#import "EBBannerView.h"
```



there are 3 ways to use:

#### 1.Show a iOS style banner with one line

```objc
[EBBannerView showWithContent:@"custom content"];
```

##### Parameters:

- default icon: app icon
- default title: app name
- `default date`: u should set localized string @"现在" =  @"now"
- `content`：banner content, NSString
- default style：will show iOS9/10/11 style up to system version





#### 2.Customize all values with a iOS style

```objc
//1.init a banner with ios9/10/11 style
EBBannerView *banner = [EBBannerView bannerViewWithStyle:EBBannerViewStyleiOS9];
 
//2.set custom values, if not set will use default values
banner.content = @"custom content";
//banner.icon = 
//banner.title = 
//banner.date = @"2017-10-23";
//...
 
//3.show
[banner show];
```

##### Parameters: 

(if not set will use default values)

- `style`：the iOS style, type enum : NSInteger {9/10/11}

- `icon`：the icon, type UIImage

- `title`：the title, type NSString

- `date`：the date, type NSString

- `content`：the content, type NSString

- `animationTime`：the animation time(show/hide the banner), type NSTimeInterval

- `stayTime`：how long the banner will stay before hide, type NSTimeInterval

- `soundID`：the sound will play when the banner is showing (when the mute is turn on iPhone will vibrate), type UInt32

  - it's iOS system sound id, default push notification sound "Tritone" is 1312
  - More sound id to see here [iOS Predefined sounds](http://iphonedevwiki.net/index.php/AudioServices#) or here [AudioServices sounds](http://www.cocoachina.com/bbs/read.php?tid=134344)

  - You can download all the system sounds [UISounds.zip](/UISounds.zip) , listen and choose one which you perfer, then check out it's `id` with the form above

- `soundName`：play a cusome sound file, type NSString
  - drag the file to Xcode proj
  - pass the file name and extension，e.g. `banner.soundName = @"sound.mp3"` 





#### 3.Show a totally custom view

```objc
//1.create new class CustomView and implement EBCustomBannerViewProtocol
@interface CustomView : UIView<EBCustomBannerViewProtocol>
@property(nonatomic, assign)CGRect portraitFrame;
@property(nonatomic, assign)CGRect landscapeFrame;
//... optional properties
@end

{...
//2.create a CustomView instance
  CustomView *customView = [[CustomView alloc] initWith...];
	
//3.set portrait/landscape frame
  customView.portraitFrame = CGRectMake(0, 50, 100, 150);
  customView.landscapeFrame = CGRectMake(200, 250, 300, 350);

//4.show
  [EBBannerView showWithCustomView:customView];
...}
```



## Handle click event and pass value

- add an observer for `EBBannerViewDidClickNotification` and handle click event
- pass an object when init the banner, and get it when clicked

```objc
#import "EBBannerView.h"
{...
  EBBannerView *banner = [EBBannerView bannerViewWithStyle:9];
  banner.object = aObject;
  [banner show];
...}

{...
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerViewDidClick:) name:EBBannerViewDidClickNotification object:nil];
...}

-(void)bannerViewDidClick:(NSNotification*)noti{
  NSLog(@"%@",noti.object);
}
```
