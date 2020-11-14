//
//  EBBannerWindow.m
//  demo
//
//  Created by pikacode@qq.com on 2017/10/23.
//  Copyright © 2017年 pikacode@qq.com. All rights reserved.
//

#import "EBBannerWindow.h"
#import "EBBannerViewController.h"
#import "EBBannerView+Categories.h"

@implementation EBBannerWindow

static EBBannerWindow *sharedWindow;

+(instancetype)sharedWindow{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL sel = @selector(initWithWindowScene:);
        if ([EBBannerWindow.new respondsToSelector:sel]) {
            id obj = [UIApplication.sharedApplication.keyWindow valueForKey:@"windowScene"];
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            sharedWindow = [[EBBannerWindow alloc] performSelector:sel withObject:obj];
            #pragma clang diagnostic pop
        } else {
            // Fallback on earlier versions
            sharedWindow = [[self alloc] initWithFrame:CGRectZero];
        }
        sharedWindow.windowLevel = UIWindowLevelNormal;
        sharedWindow.layer.masksToBounds = NO;
        [sharedWindow setHidden:NO];
        
        [EBBannerViewController setSupportedInterfaceOrientations:UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape];
        [EBBannerViewController setStatusBarHidden:NO];
        
        EBBannerViewController *vc = [EBBannerViewController new];
        vc.view.backgroundColor = [UIColor clearColor];
        vc.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        sharedWindow.rootViewController = vc;
    });
    return sharedWindow;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    __block UIView *view;
    [self.rootViewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, point)) {
            view = obj;
        }
    }];
    if (view) {
        CGPoint point1 = [self convertPoint:point toView:view];
        return [view hitTest:point1 withEvent:event];
    } else {
        if (@available(iOS 13.0, *)) {
            if (UIApplication.sharedApplication.windows.count > 0) {
                UIWindow *window = UIApplication.sharedApplication.windows[0];
                if (window.isKeyWindow) {
                    return [window hitTest:point withEvent:event];
                }
            }
            //iOS13以后，keyWindow不再是最开始创建的window，而是当前显示的window，这么写会造成某些场景死循环。
//            return [UIApplication.sharedApplication.keyWindow hitTest:point withEvent:event];
        }
        return [super hitTest:point withEvent:event];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"] && !CGRectEqualToRect(self.frame, CGRectZero)) {
        self.frame = CGRectZero;
    }
}

-(void)dealloc{
    if (@available(iOS 13.0, *)) {
        
    } else {
        [self removeObserver:self forKeyPath:@"frame"];
    }
}

@end
