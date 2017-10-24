//
//  EBBannerViewController.m
//  demo
//
//  Created by 吴星辰 on 2017/10/23.
//  Copyright © 2017年 吴星辰. All rights reserved.
//

#import "EBBannerViewController.h"
#import "EBBannerControllerView.h"

@interface EBBannerViewController ()

@end

@implementation EBBannerViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view = [[EBBannerControllerView alloc] initWithFrame:UIScreen.mainScreen.bounds];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

@end
