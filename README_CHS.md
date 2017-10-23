view [English README.md](/README.md)

QQ: 57380422
# EBForeNotification

在 App 处于前台时展示跟系统完全一样的推送`弹窗`和`声音`。获取推送内容，并且处理点击事件。

支持 iOS 7~10 beta，支持`模拟器`和`真机`运行。

## 新增
- 下滑手势
- iOS 10 弹窗样式，调用方法 (iOS 10 样式暂不支持`下滑手势`和`多行内容`)

  ```objc
  [EBForeNotification handleRemoteNotification:userInfo soundID:soundID isIos10:YES];
  //or
  [EBForeNotification handleRemoteNotification:userInfo customSound:soundName isIos10:YES];
  ```

## 效果

- 跟系统推送弹窗 UI 效果完全相同
- 可以自动获取 App 的`应用名称`，`应用图标`
- 弹窗时会自动隐藏系统状态栏、收起后自动显示系统状态栏
- 自带推送声音
- `时间`及下方`收拉条`的颜色跟当前页面的背景颜色相同
- 自带`点击事件`，点击可获取推送内容，进行相应页面跳转
- 自带`上滑手势`，快速收起
- 自带`下滑手势`，展开消息完整内容
- 自动在处于最前端的 controller 上进行弹窗

实际效果如下：

- iOS 10 以前样式

  ![](https://github.com/Yasashi/EBForeNotification/raw/master/screenshot/screenshot01.gif)

- iOS 10 样式

  ![](https://github.com/Yasashi/EBForeNotification/raw/master/screenshot/screenshot02.gif)


## 安装
### pod 安装
	platform :ios, '7.0'

	target 'YourTargetName' do
		pod 'EBForeNotification'
	end

### 手动 安装
下载并`在 Xcode 中` `拖拽拷贝` 根目录中的 `EBForeNotification` 文件夹至 Xcode 工程。


## 本地弹窗
在任意方法内调用以下任 1 行代码即可弹窗
```objc
#import "EBForeNotification.h"
{...
//普通弹窗(系统声音)
[EBForeNotification handleRemoteNotification:@{@"aps":@{@"alert":@"展示内容"}} soundID:1312];

//普通弹窗(指定声音文件)
[EBForeNotification handleRemoteNotification:@{@"aps":@{@"alert":@"展示内容"}} customSound:@"my_sound.wav"];

//带自定义参数的弹窗(系统声音)
[EBForeNotification handleRemoteNotification:@{@"aps":@{@"alert":@"展示内容"}, @"key1":@"value1", @"key2":@"value2"} soundID:1312];

//带自定义参数的弹窗(指定声音文件)
[EBForeNotification handleRemoteNotification:@{@"aps":@{@"alert":@"展示内容"}, @"key1":@"value1", @"key2":@"value2"} customSound:@"my_sound.wav"];
...}
```


## 接收远程/本地推送后弹窗
在 `AppDelegate.m` 的 `didReceiveRemoteNotification` 方法中添加代码

接收远程/本地推送后，会自动在前台展示推送弹窗及声音。

```objc
//AppDelegate.m
#import "EBForeNotification.h"

//ios7 before
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo { 
	...
	//系统声音弹窗
    [EBForeNotification handleRemoteNotification:userInfo soundID:1312];
    
    //指定声音文件弹窗
	[EBForeNotification handleRemoteNotification:userInfo customSound:@"my_sound.wav"];
    ...
}

//ios7 later  
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {    
	...
	//系统声音弹窗
    [EBForeNotification handleRemoteNotification:userInfo soundID:1312];
    
    //指定声音文件弹窗
	[EBForeNotification handleRemoteNotification:userInfo customSound:@"my_sound.wav"];
    ...
    completionHandler(UIBackgroundFetchResultNewData);
}
```

## soundID 参数
- iOS 系统自带的声音 id，系统级的推送服务默认使用的是`三全音`，id = 1312
- 其他系统声音 id 可以在这里查询到 [iOS Predefined sounds](http://iphonedevwiki.net/index.php/AudioServices#) 备用地址 [AudioServices sounds](http://www.cocoachina.com/bbs/read.php?tid=134344)


- 可以在这里 [UISounds.zip](/UISounds.zip) 下载并试听全部系统声音，然后选择自己想用的声音，根据名称对照上面提供的表格查找到相应的 `id`

## 监听并处理点击事件
添加 `Observer` 监听 `EBBannerViewDidClick`，获取推送内容，通过推送时自定义的字段处理自己逻辑，如：跳转到对应页面等。

接收到的推送内容类似以下：

```
{
    "aps":
    {
        "alert":"推送内容",
        "sound":"sound",
        "badge":"3"
    },
        "key1":"跳转页面1"  //自定义此字段以跳转到相应页面
}
```

添加 `Observer` 获取自定义的字段，并处理：

```objc
#import "EBForeNotification.h"
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eBBannerViewDidClick:) name:EBBannerViewDidClick object:nil];
-(void)eBBannerViewDidClick:(NSNotification*)noti{
    if(noti[@"key1" == @"跳转页面1"]){
        //跳转到页面1
    }
}
```

## Demo
下载运行 [EBForeNotification demo](/demo)
