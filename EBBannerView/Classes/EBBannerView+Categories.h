//
//  EBBannerView+Categories.h
//  demo
//
//  Created by 吴星辰 on 2017/10/20.
//  Copyright © 2017年 吴星辰. All rights reserved.
//

#import "EBBannerView.h"

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
