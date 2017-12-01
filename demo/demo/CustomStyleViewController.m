//
//  CustomStyleViewController.m
//  demo
//
//  Created by wxc on 2017/10/30.
//  Copyright © 2017年 吴星辰. All rights reserved.
//

#import "CustomStyleViewController.h"

#import <EBCustomBannerView.h>

#import "CustomView1.h"
#import "CustomView2.h"
#import "CustomView3.h"

@interface CustomStyleViewController ()

@end

@implementation CustomStyleViewController

- (IBAction)buttonPressed:(UIButton *)sender {
    //⭐️custom style (完全自定义样式)
    
    switch (sender.tag) {
        case 0:
        {
            //1.top (顶部)
            CustomView1 *customView1 = [[NSBundle mainBundle] loadNibNamed:@"CustomView1" owner:nil options:nil].lastObject;
            CGSize size = UIScreen.mainScreen.bounds.size;
            EBCustomBannerView *cb = [EBCustomBannerView showCustomView:customView1 block:^(EBCustomBannerViewMaker *make) {
                make.portraitFrame = CGRectMake(0, 0, MIN(size.width, size.height), 94);
                make.portraitMode = EBCustomViewAppearModeTop;
                make.soundID = 1312;
                make.stayDuration = 3.0;
                //...
            }];
            customView1.customView = cb;
        }
            break;
        case 1:
        {
            //2.left (左侧)
            CustomView2 *customView2 = [[NSBundle mainBundle] loadNibNamed:@"CustomView2" owner:nil options:nil].lastObject;
            EBCustomBannerView *cb = [EBCustomBannerView showCustomView:customView2 block:^(EBCustomBannerViewMaker *make) {
                make.portraitFrame = CGRectMake(0, 50, 300, 500);
                make.portraitMode = EBCustomViewAppearModeLeft;
                make.soundID = 1312;
                make.stayDuration = 3.0;
                //...
            }];
            customView2.customView = cb;
        }
            break;
        case 2:
        {
            //3.right (右侧)
            CustomView2 *customView2 = [[NSBundle mainBundle] loadNibNamed:@"CustomView2" owner:nil options:nil].lastObject;
            EBCustomBannerView *cb = [EBCustomBannerView showCustomView:customView2 block:^(EBCustomBannerViewMaker *make) {
                make.portraitFrame = CGRectMake(100, 50, 300, 500);
                make.portraitMode = EBCustomViewAppearModeRight;
                make.soundID = 0;
                make.stayDuration = 3;
                //...
            }];
            customView2.customView = cb;
        }
            break;
        case 3:
        {
            //4.bottom (底侧)
            CustomView1 *customView1 = [[NSBundle mainBundle] loadNibNamed:@"CustomView1" owner:nil options:nil].lastObject;
            CGSize size = UIScreen.mainScreen.bounds.size;
            customView1.customView = [EBCustomBannerView showCustomView:customView1 block:^(EBCustomBannerViewMaker *make) {
                make.portraitFrame = CGRectMake(0, 500, MIN(size.width, size.height), 94);
                make.portraitMode = EBCustomViewAppearModeBottom;
                make.soundID = 1312;
                make.stayDuration = 3.0;
                //...
            }];
        }
            break;
        case 4:
        {
            //5.center (中间)
            CustomView3 *customView3 = [[NSBundle mainBundle] loadNibNamed:@"CustomView3" owner:nil options:nil].firstObject;
            EBCustomBannerView *cv = [EBCustomBannerView showCustomView:customView3 block:^(EBCustomBannerViewMaker *make) {
                make.portraitFrame = UIScreen.mainScreen.bounds;
                make.portraitMode = EBCustomViewAppearModeCenter;
                //...
            }];
            
            customView3.customView = cv;
        }
            break;
        case 5:
        {
            //6.diff in portrait/landscape (横竖屏不同)
            CustomView3 *customView3 = [[NSBundle mainBundle] loadNibNamed:@"CustomView3" owner:nil options:nil].lastObject;
            EBCustomBannerView *cv = [EBCustomBannerView showCustomView:customView3 block:^(EBCustomBannerViewMaker *make) {
                //取中心点
                CGSize size = UIScreen.mainScreen.bounds.size;
                CGRect frame =  CGRectMake(0, 0, 230, 120);
                frame.origin.x = MIN(size.width, size.height)/2 - 230/2;
                frame.origin.y = MAX(size.width, size.height)/2 - 120/2;
                make.portraitFrame = frame;
                frame.origin.x = MAX(size.width, size.height)/2 - 230/2;
                frame.origin.y = MIN(size.width, size.height)/2 - 120/2;
                make.landscapeFrame = frame;
                make.portraitMode = EBCustomViewAppearModeLeft;
                make.landscapeMode = EBCustomViewAppearModeCenter;
                //...
            }];
            customView3.customView = cv;
        }
            break;
        default:
            break;
    }
    
    
}



@end
