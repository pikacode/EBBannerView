//
//  EBBannerViewController.m
//  demo
//
//  Created by pikacode@qq.com on 2017/10/23.
//  Copyright © 2017年 pikacode@qq.com. All rights reserved.
//

#import "EBBannerViewController.h"

@interface EBBannerViewController ()

@end

@implementation EBBannerViewController

- (instancetype)init
{
    self = [self initWithNibName:@"EBBannerViewController" bundle:[NSBundle bundleForClass:self.class]];
    if (self) {
        
    }
    return self;
}

static UIInterfaceOrientationMask supportedOrientations;

+(void)setSupportedInterfaceOrientations:(UIInterfaceOrientationMask)orientations{
    supportedOrientations = orientations;
}

+(void)setStatusBarHidden:(BOOL)hidden{
    statusBarHidden = hidden;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return supportedOrientations;
}

static BOOL statusBarHidden;
-(BOOL)prefersStatusBarHidden{
    return statusBarHidden;
}

@end
