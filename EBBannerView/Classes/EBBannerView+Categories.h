//
//  EBBannerView+Categories.h
//  demo
//
//  Created by pikacode@qq.com on 2017/10/20.
//  Copyright © 2017年 pikacode@qq.com. All rights reserved.
//

#import "EBBannerView.h"

#define WEAK_SELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface EBBannerView (EBCategory)

+(UIImage*)defaultIcon;
+(NSString*)defaultTitle;
+(NSString*)defaultDate;
+(NSTimeInterval)defaultAnimationTime;
+(NSTimeInterval)defaultStayTime;
+(UInt32)defaultSoundID;

@end

@interface NSTimer (EBCategory)

+ (NSTimer *)eb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats;

@end

@interface UIImage (EBBannerViewCategory)

+(UIColor *)colorAtPoint:(CGPoint)point;

@end
