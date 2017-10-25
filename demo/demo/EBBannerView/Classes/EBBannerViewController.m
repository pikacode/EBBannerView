//
//  EBBannerViewController.m
//  demo
//
//  Created by 吴星辰 on 2017/10/23.
//  Copyright © 2017年 吴星辰. All rights reserved.
//

#import "EBBannerViewController.h"

@interface EBBannerControllerView : UIView

@end

@implementation EBBannerControllerView
-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if ([super hitTest:point withEvent:event]) {
        return [super hitTest:point withEvent:event];
    }else{
        return self;
    }
}
@end


@interface EBBannerViewController ()

@end

@implementation EBBannerViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view = [EBBannerControllerView new];
    self.view.frame = UIScreen.mainScreen.bounds;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

@end
