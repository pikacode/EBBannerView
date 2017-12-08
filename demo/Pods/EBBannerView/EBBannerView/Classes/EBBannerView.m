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

@property (nonatomic, assign, readonly)CGFloat fixedX;
@property (nonatomic, assign, readonly)CGFloat fixedY;
@property (nonatomic, assign, readonly)CGFloat fixedWidth;

@property(nonatomic, strong)EBBannerViewMaker *maker;

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

+(instancetype)bannerWithBlock:(void(^)(EBBannerViewMaker *make))block{
    [EBBannerView sharedBannerViewInit];
    EBBannerViewMaker *maker = [EBBannerViewMaker new];
    block(maker);
    maker.style = MAX(maker.style, 9);
    
    EBBannerView *bannerView = sharedBannerViews[maker.style-9];
    bannerView.maker = maker;
    if (maker.style == EBBannerViewStyleiOS9) {
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
    SystemSoundID soundID = _maker.soundID;
    if (_maker.soundName) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:_maker.soundName withExtension:nil];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    }
    [[EBMuteDetector sharedDetecotr] detectComplete:^(BOOL isMute) {
        if (isMute) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }else{
            AudioServicesPlaySystemSound(soundID);
        }
    }];
    
    self.imageView.image = _maker.icon;
    self.titleLabel.text = _maker.title;
    self.dateLabel.text = _maker.date;
    self.contentLabel.text = _maker.content;
    self.lineView.hidden = (_maker.style == EBBannerViewStyleiOS9 && self.calculatedHeight < 34);

    [sharedWindow.rootViewController.view addSubview:self];
    
    self.frame = CGRectMake(self.fixedX, -self.standardHeight, self.fixedWidth, self.standardHeight);
    
    WEAK_SELF(weakSelf);
    [UIView animateWithDuration:_maker.animationDuration animations:^{
        weakSelf.frame = CGRectMake(weakSelf.fixedX, weakSelf.fixedY, weakSelf.fixedWidth, weakSelf.standardHeight);
    } completion:^(BOOL finished) {
        _hideTimer = [NSTimer scheduledTimerWithTimeInterval:weakSelf.maker.stayDuration target:weakSelf selector:@selector(hide) userInfo:nil repeats:NO];
    }];
}

+(void)showWithContent:(NSString*)content{
    [[EBBannerView bannerWithBlock:^(EBBannerViewMaker *make) {
        make.content = content;
    }] show];
}

#pragma mark - private

-(void)hide{
    WEAK_SELF(weakSelf);
    [UIView animateWithDuration:_maker.animationDuration animations:^{
        weakSelf.frame = CGRectMake(weakSelf.fixedX, -weakSelf.standardHeight, weakSelf.fixedWidth, weakSelf.standardHeight);
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
    [[NSNotificationCenter defaultCenter] postNotificationName:EBBannerViewDidClickNotification object:_maker.object];
    [self hide];
}

-(void)swipeUpGesture:(UISwipeGestureRecognizer*)gesture{
    if (gesture.direction == UISwipeGestureRecognizerDirectionUp) {
        [self hide];
    }
}

-(void)swipeDownGesture:(UISwipeGestureRecognizer*)gesture{
    if (_maker.style == EBBannerViewStyleiOS9) {
        if (gesture.direction == UISwipeGestureRecognizerDirectionDown && !self.lineView.hidden) {
            self.isExpand = YES;
            WEAK_SELF(weakSelf);
            CGFloat originHeight = self.contentLabel.frame.size.height;
            [UIView animateWithDuration:_maker.animationDuration animations:^{
                weakSelf.frame = CGRectMake(weakSelf.fixedX, weakSelf.fixedY, weakSelf.fixedWidth, weakSelf.standardHeight + weakSelf.calculatedHeight - originHeight + 1);
            } completion:^(BOOL finished) {
                weakSelf.frame = CGRectMake(weakSelf.fixedX, weakSelf.fixedY, weakSelf.fixedWidth, weakSelf.standardHeight + weakSelf.calculatedHeight - originHeight + 1);
            }];
        }
    }
}

#pragma mark - @property

-(CGFloat)standardHeight{
    CGFloat height;
    switch (_maker.style) {
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

-(BOOL)isiPhoneX{
    static BOOL isiPhoneX = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGSize size = UIScreen.mainScreen.bounds.size;
        isiPhoneX = MAX(size.width, size.height) == 812;
    });
    return isiPhoneX;
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

 
