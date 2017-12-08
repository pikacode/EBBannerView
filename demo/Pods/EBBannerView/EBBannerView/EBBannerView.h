//
//  EBBannerView.h
//  iOS-Foreground-Push-Notification
//
//  Created by wuxingchen on 16/7/21.
//  Copyright © 2016年 57380422@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EBCustomBannerViewProtocol;
@class EBCustomBannerView, EBBannerViewMaker;

@interface EBBannerView : UIView

//show system version style with default values
+(void)showWithContent:(NSString*)content;

//get a specific style banner, customize values below, then call 'show'
+(instancetype)bannerWithBlock:(void(^)(EBBannerViewMaker *make))block;
-(void)show;

@end

typedef enum : NSInteger {
    EBBannerViewStyleiOS9 = 9,
    EBBannerViewStyleiOS10 = 10,
    EBBannerViewStyleiOS11 = 11
} EBBannerViewStyle;

@interface EBBannerViewMaker : NSObject

@property(nonatomic, assign)EBBannerViewStyle style;//default is UIDevice.currentDevice.systemVersion.intValue
@property(nonatomic, strong)UIImage  *icon;//default is app icon
@property(nonatomic, strong)NSString *title;//default is app name
@property(nonatomic, strong)NSString *date;//default is "now" = "现在"
@property(nonatomic, strong)NSString *content;
@property(nonatomic, assign)NSTimeInterval animationDuration;//default is 0.3
@property(nonatomic, assign)NSTimeInterval stayDuration;//default is 4.0
@property(nonatomic, strong)id object;//default is content
@property(nonatomic, assign)UInt32 soundID;//default is 1312
@property(nonatomic, strong)NSString *soundName;

@end

//add observer for this notification to handle tap event and get the 'object' above
extern NSString *const EBBannerViewDidClickNotification;//监听点击弹窗的事件
