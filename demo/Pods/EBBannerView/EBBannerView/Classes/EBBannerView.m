//
//  EBBannerView.m
//  iOS-Foreground-Push-Notification
//
//  Created by pikacode@qq.com on 0/7/21.
//  Copyright © 200年 57300022@qq.com. All rights reserved.
//

#import "EBBannerView.h"
#import "EBMuteDetector.h"
#import <AudioToolbox/AudioToolbox.h>
#import "EBCustomBannerView.h"
#import "EBBannerView+Categories.h"
#import "EBBannerWindow.h"

#define kAnimationDamping 0.8

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
@property (nonatomic, assign, readonly)CGFloat calculatedContentHeight;

@property (nonatomic, assign, readonly)CGFloat fixedX;
@property (nonatomic, assign, readonly)CGFloat fixedY;
@property (nonatomic, assign, readonly)CGFloat fixedWidth;

@property(nonatomic, strong)EBBannerViewMaker *maker;

@end

@implementation EBBannerView

static NSMutableArray <EBBannerView*>*sharedBannerViews;
static EBBannerWindow *sharedWindow;

#pragma mark - public

+(instancetype)bannerWithBlock:(void(^)(EBBannerViewMaker *make))block{
    
    sharedWindow = [EBBannerWindow sharedWindow];
    
    EBBannerViewMaker *maker = [EBBannerViewMaker defaultMaker];
    block(maker);
    maker.style = MAX(maker.style, 9);
    
    EBBannerView *bannerView = [EBBannerView bannerViewWithStyle:maker.style];

    bannerView.maker = maker;
    if (maker.style == EBBannerViewStyleiOS9) {
        bannerView.dateLabel.textColor = [[UIImage colorAtPoint:bannerView.dateLabel.center] colorWithAlphaComponent:0.7];
        CGPoint lineCenter = bannerView.lineView.center;
        bannerView.lineView.backgroundColor = [[UIImage colorAtPoint:CGPointMake(lineCenter.x, lineCenter.y - 7)] colorWithAlphaComponent:0.5];
    }
    return bannerView;
}

+(instancetype)current{
    EBBannerView *view = sharedWindow.rootViewController.view.subviews.lastObject;
    if ([view isKindOfClass:[EBBannerView class]] && view.superview) {
        return view;
    } else {
        return nil;
    }
}

-(void)show{
    if (_hideTimer) {
        [_hideTimer invalidate];
        _hideTimer = nil;
    }
    SystemSoundID soundID = _maker.soundID;
    if (_maker.soundName) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:_maker.soundName withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    }
    WEAK_SELF(weakSelf);
    [[EBMuteDetector sharedDetecotr] detectComplete:^(BOOL isMute) {
        if (isMute && weakSelf.maker.vibrateOnMute) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }else{
            AudioServicesPlaySystemSound(soundID);
        }
    }];
    
    self.imageView.image = _maker.icon;
    self.titleLabel.text = _maker.title;
    self.dateLabel.text = _maker.date;
    self.contentLabel.text = _maker.content;
    self.lineView.hidden = self.calculatedContentHeight < 34;
    //iOS8 使用新样式label显示bug
    if (UIDevice.currentDevice.systemVersion.intValue < 9 && _maker.style > 9) {
        self.contentLabel.numberOfLines = 1;
    }

    [sharedWindow.rootViewController.view addSubview:self];
    
    self.frame = CGRectMake(self.fixedX, -self.standardHeight, self.fixedWidth, self.standardHeight);
    
    CGFloat damping = _maker.style == 9 ? 1 : kAnimationDamping;
    [UIView animateWithDuration:_maker.showAnimationDuration delay:0 usingSpringWithDamping:damping initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        weakSelf.frame = CGRectMake(weakSelf.fixedX, weakSelf.fixedY, weakSelf.fixedWidth, weakSelf.standardHeight);
    } completion:^(BOOL finished) {
        
        EBBannerView *strongSelf = weakSelf;
        strongSelf->_hideTimer = [NSTimer scheduledTimerWithTimeInterval:weakSelf.maker.stayDuration target:weakSelf selector:@selector(hide) userInfo:nil repeats:NO];
    }];
}

+(void)showWithContent:(NSString*)content{
    [[EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
        make.content = content;
    }] show];
}

#pragma mark - private

+(instancetype)bannerViewWithStyle:(EBBannerViewStyle)style{
    EBBannerView *bannerView;
    for (EBBannerView *view in sharedBannerViews) {
        if (view.maker.style == style) {
            bannerView = view;
            break;
        }
    }
    if (bannerView == nil) {
        NSArray *views = [[NSBundle bundleForClass:self.class] loadNibNamed:@"EBBannerView" owner:nil options:nil];
        NSUInteger index = MIN(style - 9, views.count - 1);
        bannerView = views[index];
        [[NSNotificationCenter defaultCenter] addObserver:bannerView selector:@selector(applicationDidChangeStatusBarOrientationNotification) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [bannerView addGestureRecognizer];
        [sharedBannerViews addObject:bannerView];
    }
    return bannerView;
}

-(void)hide{
    WEAK_SELF(weakSelf);
    [UIView animateWithDuration:_maker.hideAnimationDuration delay:0 usingSpringWithDamping:kAnimationDamping initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        weakSelf.frame = CGRectMake(weakSelf.fixedX, -weakSelf.standardHeight - (weakSelf.frame.size.height - weakSelf.standardHeight), weakSelf.fixedWidth, weakSelf.frame.size.height);
    } completion:^(BOOL finished) {
        
        [weakSelf removeFromSuperview];
    }];
}

-(void)applicationDidChangeStatusBarOrientationNotification{
    if (!self.superview) {
        return;
    }
    self.frame = CGRectMake(self.fixedX, self.fixedY, self.fixedWidth, self.standardHeight);
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
    if (_maker.showDetailOrHideWhenClickLongText && !self.lineView.hidden) {
        UISwipeGestureRecognizer *g = [UISwipeGestureRecognizer new];
        g.direction = UISwipeGestureRecognizerDirectionDown;
        [self swipeDownGesture:g];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:EBBannerViewDidClickNotification object:_maker.object];
        [self hide];
    }
}

-(void)swipeUpGesture:(UISwipeGestureRecognizer*)gesture{
    if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
        [self hide];
    }
}

-(void)swipeDownGesture:(UISwipeGestureRecognizer*)gesture{
    if (gesture.direction == UISwipeGestureRecognizerDirectionDown && !self.lineView.hidden) {
        if (UIDevice.currentDevice.systemVersion.intValue < 9 && _maker.style > 9) {
            self.contentLabel.numberOfLines = 0;
        }
        self.isExpand = YES;
        self.lineView.hidden = YES;
        
        [_hideTimer invalidate];
        _hideTimer = nil;
        _hideTimer = [NSTimer scheduledTimerWithTimeInterval:_maker.swipeDownStayDuration target:self selector:@selector(hide) userInfo:nil repeats:NO];
        
        WEAK_SELF(weakSelf);
        CGFloat originContentHeight = self.contentLabel.frame.size.height;
        [UIView animateWithDuration:_maker.hideAnimationDuration delay:0 usingSpringWithDamping:kAnimationDamping initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            weakSelf.frame = CGRectMake(weakSelf.fixedX, weakSelf.fixedY, weakSelf.fixedWidth, weakSelf.standardHeight + weakSelf.calculatedContentHeight - originContentHeight + 1);
        } completion:^(BOOL finished) {
            
            weakSelf.frame = CGRectMake(weakSelf.fixedX, weakSelf.fixedY, weakSelf.fixedWidth, weakSelf.standardHeight + weakSelf.calculatedContentHeight - originContentHeight + 1);
        }];
    }
}

#pragma mark - @property

-(CGFloat)standardHeight{
    switch (_maker.style) {
        case EBBannerViewStyleiOS8:
        case EBBannerViewStyleiOS9:
            return 70;
        case EBBannerViewStyleiOS10:
        case EBBannerViewStyleiOS11:
        case EBBannerViewStyleiOS12:
            return 90;
    }
}

-(CGFloat)calculatedContentHeight{
    CGSize size = CGSizeMake(self.contentLabel.frame.size.width, MAXFLOAT);
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:self.contentLabel.font.pointSize] forKey:NSFontAttributeName];
    CGFloat calculatedHeight = [self.contentLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size.height;
    return calculatedHeight;
}

-(BOOL)isiPhoneX{
    if(@available(iOS 11.0, *)) {
        return UIApplication.sharedApplication.delegate.window.safeAreaInsets.bottom > 0;
    } else {
        return NO;
    }
}

-(CGFloat)fixedX{
    return ([self isiPhoneX] && ![self isPortrait]) ? 128 : 0;
}

-(CGFloat)fixedY{
    return ([self isiPhoneX] && [self isPortrait]) ? 33 : 0;
}

-(CGFloat)fixedWidth{
    return ([self isiPhoneX] && ![self isPortrait]) ? 556 : ScreenWidth;
}

-(BOOL)isPortrait{
    return ScreenWidth < ScreenHeight;
}

@end

 
