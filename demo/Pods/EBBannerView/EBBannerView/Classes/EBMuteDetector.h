//
//  EBMuteSwitchDetector.h
//
//  Created by 57380422@qq.com on 6/2/13.
//  Copyright (c) 2013 57380422@qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EBMuteDetector : NSObject

+(EBMuteDetector*)sharedDetecotr;

-(void)detectComplete:(void (^)(BOOL isMute))completionHandler;

@end
