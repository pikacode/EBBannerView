//
//  EBBannerControllerView.m
//  demo
//
//  Created by 吴星辰 on 2017/10/24.
//  Copyright © 2017年 吴星辰. All rights reserved.
//

#import "EBBannerControllerView.h"

@implementation EBBannerControllerView

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (CGRectContainsPoint(self.frame, point)) {
        return self;
    }else{
        return [super hitTest:point withEvent:event];
    }
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return YES;
}

@end
