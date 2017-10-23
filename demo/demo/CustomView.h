//
//  CustomView.h
//  demo
//
//  Created by 吴星辰 on 2017/10/19.
//  Copyright © 2017年 吴星辰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBBannerView.h"

@interface CustomView : UIView<EBCustomBannerViewProtocol>
@property(nonatomic, assign)CGRect portraitFrame;
@property(nonatomic, assign)CGRect landscapeFrame;
@end
