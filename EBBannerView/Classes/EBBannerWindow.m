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
        if (@available(iOS 13.0,*)) {
            NSSet *scenes = UIApplication.sharedApplication.connectedScenes;
            __block UIScene *scene;
            [scenes enumerateObjectsUsingBlock:^(UIScene   * _Nonnull  obj, BOOL * _Nonnull stop) {
                if (obj.activationState == UISceneActivationStateForegroundActive && [obj isKindOfClass:[UIWindowScene class]]) {
                    scene = obj;
                    *stop = YES;
                }
            }];
            sharedWindow = [[self alloc] initWithWindowScene:(UIWindowScene *)scene];
            sharedWindow.userInteractionEnabled = NO;
            [sharedWindow setHidden:NO];
        }else{
            sharedWindow = [[self alloc] initWithFrame:CGRectZero];
        }
        sharedWindow.windowLevel = UIWindowLevelAlert;
        sharedWindow.layer.masksToBounds = NO;
        UIWindow *originKeyWindow = UIApplication.sharedApplication.keyWindow;
        if (@available(iOS 13.0,*)) {
            
        }else {
            [sharedWindow makeKeyAndVisible];
        }
        
        /* fix bug:
         EBBannerViewController setSupportedInterfaceOrientations -> Portrait
         push to a VC with orientation Left
         UITextFiled's pad will show a wrong orientation with Portrait
         */
        if (@available(iOS 13.0,*)) {
            NSSet *scenes = UIApplication.sharedApplication.connectedScenes;
            __block UIScene *scene;
            [scenes enumerateObjectsUsingBlock:^(UIScene   * _Nonnull  obj, BOOL * _Nonnull stop) {
                if (obj.activationState == UISceneActivationStateForegroundActive && [obj isKindOfClass:[UIWindowScene class]]) {
                    scene = obj;
                    *stop = YES;
                }
            }];
            emptyWindow = [[EBEmptyWindow alloc] initWithWindowScene:(UIWindowScene *)scene];
            emptyWindow.frame = CGRectZero;
            [emptyWindow setHidden:NO];
        }else{
            emptyWindow = [[EBEmptyWindow alloc] initWithFrame:CGRectZero];
        }
        emptyWindow.windowLevel = UIWindowLevelAlert;
        if (@available(iOS 13.0,*)) {
            
        }else{
            [emptyWindow makeKeyAndVisible];
            [originKeyWindow makeKeyAndVisible];
        }
        
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
    }else{
        return [super hitTest:point withEvent:event];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"] && !CGRectEqualToRect(self.frame, CGRectZero)) {
        self.frame = CGRectZero;
    }
}

-(void)dealloc{
    [self removeObserver:self forKeyPath:@"frame"];
}

@end
