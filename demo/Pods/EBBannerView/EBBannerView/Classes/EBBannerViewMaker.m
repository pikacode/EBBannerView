//
//  EBBannerViewMaker.m
//  EBBannerView
//
//  Created by wxc on 2017/11/27.
//

#import "EBBannerView.h"

@implementation EBBannerViewMaker

+(instancetype)defaultMaker{
    EBBannerViewMaker *maker = [EBBannerViewMaker new];
    maker.style = MAX(UIDevice.currentDevice.systemVersion.intValue, 9);
    maker.icon = [UIImage imageNamed:@"AppIcon40x40"] ?: [UIImage imageNamed:@"AppIcon60x60"] ?: [UIImage imageNamed:@"AppIcon80x80"];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    maker.title = [infoDictionary objectForKey:@"CFBundleDisplayName"] ?: [infoDictionary objectForKey:@"CFBundleName"];
    maker.date = NSLocalizedString(@"现在", nil);
    maker.content = @"";
    maker.showAnimationDuration = 0.3;
    maker.hideAnimationDuration = 0.5;
    maker.stayDuration = 4;
    maker.swipeDownStayDuration = 4;
    maker.soundID = 1312;
    maker.vibrateOnMute = YES;
    maker.showDetailOrHideWhenClickLongText = YES;
    return maker;
}

-(void)setStyle:(EBBannerViewStyle)style{
    if (style < 9) {
        _style = EBBannerViewStyleiOS9;
    } else if (style > 12) {
        _style = EBBannerViewStyleiOS12;
    } else {
        _style = style;
    }
}

-(id)object{
    if (!_object) {
        _object = self.content.copy;
    }
    return _object;
}

@end
