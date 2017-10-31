view [English README.md](/README.md)

Email：pikacode@qq.com

QQ群: 345192153
# EBBannerView

只需一行代码即可：

- App 在前台时展示跟 iOS9/10/11 推送通知一样 UI 的横幅，自动根据系统版本显示不同 UI


- 根据手机是否静音自动播放提示音或振动
- iOS 9 样式支持下拉手势

并且可以：

- 自定义横幅的图标、标题、时间、内容、动画时间
- 自定义弹出时的声音，可选用系统提示音，或者自己添加声音文件
- 横竖屏自适应


- 完全自定义弹出的 view，自定义 view 在横竖屏时可以定制不同的 frame
- 自定义 view 在横竖屏时支持分别从不同方向弹出（屏幕上下左右中心）
- 监听点击事件、传值
- 支持模拟器和真机



## 效果

  ![](https://github.com/pikacode/EBBannerView/screenshot/screenshot01.gif)



## 安装
### pod 安装

	target 'YourTargetName' do
	  pod 'EBBannerView'
	end




## 使用
```objc
#import <EBBannerView.h>
```



有以下三种使用方式：

#### 方式一：一行代码搞定之省心模式

```objc
[EBBannerView showWithContent:@"自定义内容"];
```

##### 参数说明

- 图标默认显示：app 的图标
- 标题默认显示：app 的名称
- 时间默认显示：NSLocalizedString(@"现在", nil)
- `content`：指定展示的内容，类型 NSString
- 样式：根据系统判断自动展示 iOS9/10/11 的样式



#### 方式二：指定系统样式，并自定义内容

```objc
//1.根据指定样式初始化
EBBannerView *banner = [EBBannerView bannerViewWithStyle:EBBannerViewStyleiOS9];
 
//2.自定义赋值，没有指定的会使用默认值
banner.content = @"自定义内容";
//banner.icon = 
//banner.title = 
//...
 
//3.展示
[banner show];
```

##### 参数说明 

（以下参数不赋值时均使用默认值）

- `style`：需要展示的样式，类型 enum : NSInteger {9/10/11}
- `icon`：图片，类型 UIImage
- `title`：标题，类型 NSString
- `date`：时间，类型 NSString
- `content`：内容，类型 NSString
- `animationTime`：显示/隐藏动画时间，类型 NSTimeInterval
- `stayTime`：隐藏之前停留显示的时间，类型 NSTimeInterval
- `soundID`：播放的提示音（静音时会自动振动），类型 UInt32
  - 该参数是 iOS 系统自带的声音 id，默认使用的是`三全音`，id = 1312
  - 其他系统声音 id 可以在这里查询到 [iOS Predefined sounds](http://iphonedevwiki.net/index.php/AudioServices#) 备用地址 [AudioServices sounds](http://www.cocoachina.com/bbs/read.php?tid=134344)
  - 可以在这里 [UISounds.zip](/UISounds.zip) 下载并试听全部系统声音，然后选择自己想用的声音，根据名称对照上面提供的表格查找到相应的 `id`
- `soundName`：播放自定义的声音文件，类型 NSString
  - 直接将声音文件拖拽到工程目录
  - 赋值时包含拓展名，例 sound.mp3



#### 方式三：完全自定义展示的 view

```objc
//1.新建类 CustomView，需遵从 EBCustomBannerViewProtocol 协议
@interface CustomView : UIView<EBCustomBannerViewProtocol>
@property(nonatomic, assign)CGRect portraitFrame;
@property(nonatomic, assign)CGRect landscapeFrame;
//...其他参数可选添加
@end

{...
//2.创建 CustomView 实例
  CustomView *customView = [[CustomView alloc] initWith...];
	
//3.分别指定横竖屏时的 frame
  customView.portraitFrame = CGRectMake(0, 50, 100, 150);
  customView.landscapeFrame = CGRectMake(200, 250, 300, 350);

//4.展示
  [EBBannerView showWithCustomView:customView];
...}
```



## 监听、处理点击事件、传值

- 通过监听`EBBannerViewDidClickNotification`通知，处理点击事件。
- 如果初始化 banner 的时候传了 object 的值，在点击后可以获取到。

```objc
#import <EBBannerView.h>
{...
  banner.object = aObject;
...}

{...
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerViewDidClick:) name:EBBannerViewDidClickNotification object:nil];
...}

-(void)bannerViewDidClick:(NSNotification*)noti{
  NSLog(@"%@",noti.object);
}
```
