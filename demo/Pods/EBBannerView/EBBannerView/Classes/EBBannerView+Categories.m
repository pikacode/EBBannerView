//
//  EBBannerView+Categories.m
//  demo
//
//  Created by pikacode@qq.com on 2017/10/20.
//  Copyright © 2017年 pikacode@qq.com. All rights reserved.
//

#import "EBBannerView+Categories.h"
#import "EBBannerView.h"

@implementation EBBannerView (EBCategory)

+(UIImage*)defaultIcon{
    return [UIImage imageNamed:@"AppIcon40x40"] ?: [UIImage imageNamed:@"AppIcon60x60"] ?: [UIImage imageNamed:@"AppIcon80x80"];
}

+(NSString*)defaultTitle{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleDisplayName"] ?: [infoDictionary objectForKey:@"CFBundleName"];
}

+(NSString*)defaultDate{
    return NSLocalizedString(@"现在", nil);
}

+(NSTimeInterval)defaultAnimationTime{
    return 0.3;
}


+(NSTimeInterval)defaultStayTime{
    return 4;
}

+(UInt32)defaultSoundID{
    return 1312;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (CGRectContainsPoint(self.frame, point)) {
        return self;
    }else{
        return [super hitTest:point withEvent:event];
    }
}

@end

@implementation NSTimer (EBCategory)

+ (void)_eb_ExecBlock:(NSTimer *)timer {
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}
+ (NSTimer *)eb_scheduledTimerWithTimeInterval:(NSTimeInterval)interval block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats {
    return [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(_eb_ExecBlock:) userInfo:[block copy] repeats:repeats];
}

@end

@implementation UIImage (EBBannerViewCategory)

+(UIColor *)colorAtPoint:(CGPoint)point{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);//全屏截图，包括window
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, viewImage.size.width, viewImage.size.height), point)) {
        return nil;
    }
    NSInteger pointX = trunc(point.x);
    NSInteger pointY = trunc(point.y);
    CGImageRef cgImage = viewImage.CGImage;
    NSUInteger width = viewImage.size.width;
    NSUInteger height = viewImage.size.height;
    viewImage = nil;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    int bytesPerRow = bytesPerPixel * 1;
    NSUInteger bitsPerComponent = 8;
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    UIGraphicsEndImageContext();
    CGContextRelease(context);
    CGFloat red = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
