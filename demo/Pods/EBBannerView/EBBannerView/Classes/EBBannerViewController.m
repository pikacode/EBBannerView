//
//  EBBannerViewController.m
//  demo
//
//  Created by 吴星辰 on 2017/10/23.
//  Copyright © 2017年 吴星辰. All rights reserved.
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
