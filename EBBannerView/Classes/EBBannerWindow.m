//
//  EBBannerWindow.m
//  demo
//
//  Created by 吴星辰 on 2017/10/23.
//  Copyright © 2017年 吴星辰. All rights reserved.
//

#import "EBBannerWindow.h"

@implementation EBBannerWindow

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
        return [view hitTest:point withEvent:event];
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
