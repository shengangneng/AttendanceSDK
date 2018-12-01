//
//  MPMSigninTimerTask.h
//  MPMAtendence
//  计时器代理，避免循环引用
//  Created by shengangneng on 2018/11/30.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPMSigninTimerTask : NSObject

- (instancetype)initWithTarget:(id)target selector:(SEL)selector;

- (void)pauseTimer;
- (void)resumeTimer;
- (void)shutdownTimer;

@end

NS_ASSUME_NONNULL_END
