//
//  EBCustomBannerView.h
//  demo
//
//  Created by 吴星辰 on 2017/10/20.
//  Copyright © 2017年 吴星辰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EBBannerView.h"

@interface EBCustomBannerView : UIView <EBCustomBannerViewProtocol>
@property(nonatomic, assign)CGRect portraitFrame;
@property(nonatomic, assign)CGRect landscapeFrame;
@property(nonatomic, strong)NSNumber *soundID;
@property(nonatomic, strong)NSString *soundName;
@property(nonatomic, strong)NSNumber *animationTime;
@property(nonatomic, strong)NSNumber *stayTime;
@end
