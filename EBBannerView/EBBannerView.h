//
//  EBBannerView.h
//  iOS-Foreground-Push-Notification
//
//  Created by wuxingchen on 16/7/21.
//  Copyright © 2016年 57380422@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EBCustomBannerViewProtocol;

typedef enum : NSInteger {
    EBBannerViewStyleiOS9 = 9,
    EBBannerViewStyleiOS10 = 10,
    EBBannerViewStyleiOS11 = 11
} EBBannerViewStyle;

//-----------------------------------------------------------------

@interface EBBannerView : UIView

+(void)showWithContent:(NSString*)content;

+(EBBannerView*)bannerViewWithStyle:(EBBannerViewStyle)style;
-(void)show;

+(void)showWithCustomView:(UIView<EBCustomBannerViewProtocol>*)view;

@property(nonatomic, strong)UIImage  *icon;
@property(nonatomic, strong)NSString *title;
@property(nonatomic, strong)NSString *date;
@property(nonatomic, strong)NSString *content;
@property(nonatomic, assign)NSTimeInterval animationTime;
@property(nonatomic, assign)NSTimeInterval stayTime;
@property(nonatomic, strong)id object;
@property(nonatomic, assign)UInt32 soundID;
@property(nonatomic, strong)NSString *soundName;

@end

//-----------------------------------------------------------------

@protocol EBCustomBannerViewProtocol <NSObject>
@required
@property(nonatomic, assign)CGRect portraitFrame;
@property(nonatomic, assign)CGRect landscapeFrame;
@optional
@property(nonatomic, strong)NSNumber *soundID;
@property(nonatomic, strong)NSString *soundName;
@property(nonatomic, strong)NSNumber *animationTime;
@property(nonatomic, strong)NSNumber *stayTime;
@end

extern NSString *const EBBannerViewDidClickNotification;//监听点击弹窗的事件

