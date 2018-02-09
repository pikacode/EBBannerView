//
//  EBCustomBannerView.h
//  demo
//
//  Created by pikacode@qq.com on 2017/10/20.
//  Copyright © 2017年 pikacode@qq.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    EBCustomViewAppearModeTop,//default
    EBCustomViewAppearModeLeft,
    EBCustomViewAppearModeRight,
    EBCustomViewAppearModeBottom,
    EBCustomViewAppearModeCenter
} EBCustomBannerViewAppearMode;

@class EBCustomBannerViewMaker;
@interface EBCustomBannerView : NSObject

//make a custom view and show immediately,
+(instancetype)showCustomView:(UIView*)view block:(void(^)(EBCustomBannerViewMaker *make))block;

//make a custom view and show later
+(instancetype)customView:(UIView*)view block:(void(^)(EBCustomBannerViewMaker *make))block;

-(void)show;
-(void)hide;

@end

@interface EBCustomBannerViewMaker : NSObject

@property(nonatomic, assign)CGRect portraitFrame;//default is view.frame
@property(nonatomic, assign)CGRect landscapeFrame;//default is portraitFrame
@property(nonatomic, assign)UInt32 soundID;//default is 0
@property(nonatomic, strong)NSString *soundName;
@property(nonatomic, assign)NSTimeInterval animationDuration;//default is 0.3
@property(nonatomic, assign)NSTimeInterval stayDuration;//default is 4.0, set 0 will not hide
@property(nonatomic, assign)EBCustomBannerViewAppearMode portraitMode;//default is top
@property(nonatomic, assign)EBCustomBannerViewAppearMode landscapeMode;//default is top

@property(nonatomic, strong)NSArray<NSNumber*>*centerModeDurations;//default is @[@0.3, @0.2, @0.1];

@property(nonatomic, assign)BOOL vibrateOnMute;//default is YES

@end
