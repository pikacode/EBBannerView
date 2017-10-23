//
//  EBMuteSwitchDetector.m
//
//  Created by 57380422@qq.comon 6/2/13.
//  Copyright (c) 2013 57380422@qq.com. All rights reserved.
//

#import "EBMuteDetector.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

@interface EBMuteDetector()

@property (nonatomic,assign) NSTimeInterval interval;

@property (nonatomic,assign) SystemSoundID soundId;


typedef void (^DetectCompleteBlock)(BOOL isMute);

@property(nonatomic, copy)DetectCompleteBlock completeBlock;

@end

@implementation EBMuteDetector

void EBSoundMuteNotificationCompletionProc(SystemSoundID  ssID,void* clientData){
    NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - [EBMuteDetector sharedDetecotr].interval;
    BOOL isMute = elapsed < 0.1;
    [EBMuteDetector sharedDetecotr].completeBlock(isMute);
}

+(EBMuteDetector*)sharedDetecotr{
    static EBMuteDetector* sharedDetecotr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDetecotr = [EBMuteDetector new];
        NSURL* url = [[NSBundle bundleForClass:[self class]] URLForResource:@"EBMute" withExtension:@"mp3"];
        if (AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &sharedDetecotr->_soundId) == kAudioServicesNoError){
            AudioServicesAddSystemSoundCompletion(sharedDetecotr.soundId, CFRunLoopGetMain(), kCFRunLoopDefaultMode, EBSoundMuteNotificationCompletionProc,(__bridge void *)(self));
            UInt32 yes = 1;
            AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(sharedDetecotr.soundId),&sharedDetecotr->_soundId,sizeof(yes), &yes);
        } else {
            sharedDetecotr.soundId = -1;
        }
    });
    return sharedDetecotr;
}

-(void)detectComplete:(void (^)(BOOL isMute))completionHandler{
    self.interval = [NSDate timeIntervalSinceReferenceDate];
    AudioServicesPlaySystemSound(self.soundId);
    self.completeBlock = completionHandler;
}

-(void)dealloc{
    if (self.soundId != -1){
        AudioServicesRemoveSystemSoundCompletion(self.soundId);
        AudioServicesDisposeSystemSoundID(self.soundId);
    }
}

@end
