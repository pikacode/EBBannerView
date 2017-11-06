//
//  EBBannerView.m
//  iOS-Foreground-Push-Notification
//
//  Created by wuxingchen on 0/7/21.
//  Copyright © 200年 57300022@qq.com. All rights reserved.
//

#import "EBBannerView.h"
#import "EBMuteDetector.h"
#import <AudioToolbox/AudioToolbox.h>
#import "EBCustomBannerView.h"
#import "EBBannerView+Categories.h"
#import "EBBannerWindow.h"

NSString *const EBBannerViewDidClickNotification = @"EBBannerViewDidClickNotification";

@interface EBBannerView(){
    NSTimer *_hideTimer;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, assign)BOOL isExpand;
@property(nonatomic, assign, readonly)CGFloat standardHeight;
@property (nonatomic, assign, readonly)CGFloat calculatedHeight;
@property(nonatomic, assign)EBBannerViewStyle style;

@end

@implementation EBBannerView

static NSArray <EBBannerView*>*sharedBannerViews;
static EBBannerWindow *sharedWindow;

#pragma mark - public

+(void)sharedBannerViewInit{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWindow = [EBBannerWindow sharedWindow];
        sharedBannerViews = [[NSBundle bundleForClass:self.class] loadNibNamed:@"EBBannerView" owner:nil options:nil];
        [sharedBannerViews enumerateObjectsUsingBlock:^(EBBannerView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSNotificationCenter defaultCenter] addObserver:obj selector:@selector(applicationDidChangeStatusBarOrientationNotification) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
            [obj addGestureRecognizer];
        }];
    });
}

+(EBBannerView*)bannerViewWithStyle:(EBBannerViewStyle)style{
    [EBBannerView sharedBannerViewInit];
    if (style < 9) {
        style = 9;
    }
    EBBannerView *bannerView = sharedBannerViews[style-9];
    bannerView.style = style;
    if (style == EBBannerViewStyleiOS9) {
        bannerView.dateLabel.textColor = [[UIImage colorAtPoint:bannerView.dateLabel.center] colorWithAlphaComponent:0.7];
        CGPoint lineCenter = bannerView.lineView.center;
        bannerView.lineView.backgroundColor = [[UIImage colorAtPoint:CGPointMake(lineCenter.x, lineCenter.y - 7)] colorWithAlphaComponent:0.5];
    }
    return bannerView;
}

-(void)show{
    if (_hideTimer) {
        [_hideTimer invalidate];
        _hideTimer = nil;
    }
    SystemSoundID soundID = self.soundID;
    if (self.soundName) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:self.soundName withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    }
    [[EBMuteDetector sharedDetecotr] detectComplete:^(BOOL isMute) {
        if (isMute) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }else{
            AudioServicesPlaySystemSound(soundID);
        }
    }];
    
    self.imageView.image = self.icon;
    self.titleLabel.text = self.title;
    self.dateLabel.text = self.date;
    self.contentLabel.text = self.content;
    self.lineView.hidden = (self.style == EBBannerViewStyleiOS9 && self.calculatedHeight < 34);

    [sharedWindow.rootViewController.view addSubview:self];
    
    self.frame = CGRectMake(0, -self.standardHeight, ScreenWidth, self.standardHeight);
    
    WEAK_SELF(weakSelf);
    [UIView animateWithDuration:self.animationDuration animations:^{
        weakSelf.frame = CGRectMake(0, 0, ScreenWidth, weakSelf.standardHeight);
    } completion:^(BOOL finished) {
        _hideTimer = [NSTimer scheduledTimerWithTimeInterval:weakSelf.stayDuration target:weakSelf selector:@selector(hide) userInfo:nil repeats:NO];
    }];
}

+(void)showWithContent:(NSString*)content{
    EBBannerViewStyle style = [UIDevice currentDevice].systemVersion.intValue;
    EBBannerView *bannerView = [EBBannerView bannerViewWithStyle:style];
    bannerView.content = content;
    bannerView.soundID = 1312;
    [bannerView show];
}

#pragma mark - private

-(void)hide{
    WEAK_SELF(weakSelf);
    [UIView animateWithDuration:self.animationDuration animations:^{
        weakSelf.frame = CGRectMake(0, -weakSelf.standardHeight, ScreenWidth, weakSelf.standardHeight);
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

-(void)applicationDidChangeStatusBarOrientationNotification{
    if (!self.superview) {
        return;
    }
    CGSize size = UIScreen.mainScreen.bounds.size;
    CGFloat w = MIN(size.width, size.height);
    CGFloat h = MAX(size.width, size.height);
    if (UIDeviceOrientationIsLandscape(UIDevice.currentDevice.orientation)) {
        self.frame = CGRectMake(0, 0, h, self.standardHeight);
    }else{
        self.frame = CGRectMake(0, 0, w, self.standardHeight);
    }
}

-(void)addGestureRecognizer{
    UISwipeGestureRecognizer *swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUpGesture:)];
    swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer:swipeUpGesture];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:tapGesture];

    UISwipeGestureRecognizer *swipeDownGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDownGesture:)];
    swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer:swipeDownGesture];
}

-(void)tapGesture:(UITapGestureRecognizer*)tapGesture{
    [[NSNotificationCenter defaultCenter] postNotificationName:EBBannerViewDidClickNotification object:self.object];
    [self hide];
}

-(void)swipeUpGesture:(UISwipeGestureRecognizer*)gesture{
    if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
        [self hide];
    }
}

-(void)swipeDownGesture:(UISwipeGestureRecognizer*)gesture{
    if (self.style == EBBannerViewStyleiOS9) {
        if (gesture.direction == UISwipeGestureRecognizerDirectionDown && !self.lineView.hidden) {
            self.isExpand = YES;
            WEAK_SELF(weakSelf);
            CGFloat originHeight = self.contentLabel.frame.size.height;
            [UIView animateWithDuration:self.animationDuration animations:^{
                weakSelf.frame = CGRectMake(0, 0, ScreenWidth, weakSelf.standardHeight + weakSelf.calculatedHeight - originHeight + 1);
            } completion:^(BOOL finished) {
                weakSelf.frame = CGRectMake(0, 0, ScreenWidth, weakSelf.standardHeight + weakSelf.calculatedHeight - originHeight + 1);
            }];
        }
    }
}

#pragma mark - @property

-(UIImage *)icon{
    if (!_icon) {
        _icon = [EBBannerView defaultIcon];
    }
    return _icon;
}

-(NSString *)title{
    if (!_title) {
        _title = [EBBannerView defaultTitle];
    }
    return _title ?: @"";
}

-(NSString *)date{
    if (!_date) {
        _date = [EBBannerView defaultDate];
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
        _animationDuration = [EBBannerView defaultAnimationTime];
    }
    return _animationDuration;
}

-(NSTimeInterval)stayDuration{
    if (!_stayDuration) {
        _stayDuration = [EBBannerView defaultStayTime];;
    }
    return _stayDuration;
}

-(CGFloat)standardHeight{
    CGFloat height;
    switch (self.style) {
        case EBBannerViewStyleiOS9:
            height = 70;
            break;
        case EBBannerViewStyleiOS10:
            height = 90;
            break;
        case EBBannerViewStyleiOS11:
            height = 90;
            break;
        default:
            height = 70;
            break;
    }
    return height;
}

-(CGFloat)calculatedHeight{
    CGSize size = CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT);
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:self.contentLabel.font.pointSize] forKey:NSFontAttributeName];
    CGFloat calculatedHeight = [self.contentLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    return calculatedHeight;
}

-(UInt32)soundID{
    if (_soundID == 0) {
        _soundID = [EBBannerView defaultSoundID];
    }
    return _soundID;
}

@end

 
