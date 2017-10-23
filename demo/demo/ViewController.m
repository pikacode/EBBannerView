//
//  ViewController.m
//  demo
//
//  Created by 吴星辰 on 2017/10/16.
//  Copyright © 2017年 吴星辰. All rights reserved.
//

#import "ViewController.h"
#import "EBBannerView.h"
#import "CustomView.h"

@interface CALayer(EB)
@end
@implementation CALayer(EB)
-(void)setBorderUIColor:(UIColor*)uicolor{
    self.borderColor = uicolor.CGColor;
}
@end

@interface ViewController ()

@end

@implementation ViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bannerDidClick:) name:EBBannerViewDidClickNotification object:nil];
}

-(void)bannerDidClick:(NSNotification*)noti{
    //noti.object
}

- (IBAction)buttonPressed:(UIButton*)sender {
    switch (sender.tag) {
        case 0:
            [EBBannerView showWithContent:@"aaaa"];
            break;
        case 1:
        {
            EBBannerView *banner = [EBBannerView bannerViewWithStyle:EBBannerViewStyleiOS9];
            banner.content = @"MINE eye hath played the painter and hath stelled";
            //banner.object = ...
            [banner show];
        }
            break;
        case 2:
        {
            EBBannerView *banner = [EBBannerView bannerViewWithStyle:EBBannerViewStyleiOS9];
            banner.content = @"MINE eye hath played the painter and hath stelled Thy beauty's form in table of my heart;My body is the frame wherein 'tis held,And perspective it is best painter's art.For through the painter must you see his skillTo fine where your true image pictured lies,Which in my bosom's shop is hanging still,That hath his windows glazèd with thine eyes.";
            [banner show];
        }
            break;
        case 3:
        {
            EBBannerView *banner = [EBBannerView bannerViewWithStyle:10];
            banner.content = @"ios 10 style";
            [banner show];
        }
            break;
        case 4:
        {
            EBBannerView *banner = [EBBannerView bannerViewWithStyle:EBBannerViewStyleiOS11];
            banner.icon = [UIImage imageNamed:@"icon"];
            banner.title = @"custom title";
            banner.content = @"ios 11 style";
            banner.date = @"2017 10 19";
            [banner show];
        }
            break;
        case 5:
        {
            //自定义view
            CustomView *customView = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:nil options:nil].lastObject;
            CGSize size = UIScreen.mainScreen.bounds.size;
            customView.portraitFrame = CGRectMake(0, 0, size.width, 230);
            customView.landscapeFrame = CGRectMake(0, 0, size.height, 330);
            [EBBannerView showWithCustomView:customView];
        }
            break;
        default:
            break;
    }
}


@end
