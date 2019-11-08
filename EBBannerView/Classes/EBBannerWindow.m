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
#import "EBEmptyWindow.h"

@implementation EBBannerWindow

static EBBannerWindow *sharedWindow;
static EBEmptyWindow *emptyWindow;

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
        sharedWindow.windowLevel = UIWindowLevelAlert;
        sharedWindow.layer.masksToBounds = NO;
        UIWindow *originKeyWindow = UIApplication.sharedApplication.keyWindow;
        [sharedWindow makeKeyAndVisible];
        
        /* fix bug:
         EBBannerViewController setSupportedInterfaceOrientations -> Portrait
         push to a VC with orientation Left
         UITextFiled's pad will show a wrong orientation with Portrait
         */
        emptyWindow = [[EBEmptyWindow alloc] initWithFrame:CGRectZero];
        emptyWindow.windowLevel = UIWindowLevelAlert;
        [emptyWindow makeKeyAndVisible];
        [originKeyWindow makeKeyAndVisible];
        
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
            return [UIApplication.sharedApplication.keyWindow hitTest:point withEvent:event];
        } else {
            return [super hitTest:point withEvent:event];
        }
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
