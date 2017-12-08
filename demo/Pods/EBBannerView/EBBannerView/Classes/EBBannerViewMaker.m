//
//  EBBannerViewMaker.m
//  EBBannerView
//
//  Created by wxc on 2017/11/27.
//

#import "EBBannerView.h"

@implementation EBBannerViewMaker

-(EBBannerViewStyle)style{
    if (!_style) {
        _style = MAX(UIDevice.currentDevice.systemVersion.intValue, 9);
    }
    return _style;
}

-(UIImage *)icon{
    if (!_icon) {
        _icon = [UIImage imageNamed:@"AppIcon40x40"] ?: [UIImage imageNamed:@"AppIcon60x60"] ?: [UIImage imageNamed:@"AppIcon80x80"];
    }
    return _icon;
}

-(NSString *)title{
    if (!_title) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _title = [infoDictionary objectForKey:@"CFBundleDisplayName"] ?: [infoDictionary objectForKey:@"CFBundleName"];
    }
    return _title ?: @"";
}

-(NSString *)date{
    if (!_date) {
        _date = NSLocalizedString(@"现在", nil);
    }
    return _date;
}

-(NSString *)content{
    if (!_content) {
        _content = @"";
    }
    return _content;
}

-(NSTimeInterval)animationDuration{
    if (!_animationDuration) {
        _animationDuration = 0.3;
    }
    return _animationDuration;
}

-(NSTimeInterval)stayDuration{
    if (!_stayDuration) {
        _stayDuration = 4;
    }
    return _stayDuration;
}

-(UInt32)soundID{
    if (_soundID == 0) {
        _soundID = 1312;
    }
    return _soundID;
}

-(id)object{
    if (!_object) {
        _object = self.content.copy;
    }
    return _object;
}

@end
