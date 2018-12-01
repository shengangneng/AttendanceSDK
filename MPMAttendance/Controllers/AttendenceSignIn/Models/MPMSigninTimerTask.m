//
//  MPMSigninTimerTask.m
//  MPMAtendence
//  计时器代理，避免循环引用
//  Created by shengangneng on 2018/11/30.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSigninTimerTask.h"

@interface MPMSigninTimerTask ()

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) CADisplayLink *timer;

@end

@implementation MPMSigninTimerTask

- (instancetype)initWithTarget:(id)target selector:(SEL)selector {
    self = [super init];
    if (self) {
        self.target = target;
        self.selector = selector;
        self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(timeChange)];
    }
    return self;
}

- (void)timeChange {
    __weak typeof(self) weakself = self;
    dispatch_async(kMainQueue, ^{
        __strong typeof(weakself) strongself = weakself;
        if (strongself.target && [strongself.target respondsToSelector:strongself.selector]) {
            [strongself.target performSelector:self.selector withObject:nil];
        }
    });
}

- (void)pauseTimer {
    [self.timer removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)resumeTimer {
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)shutdownTimer {
    [self.timer invalidate];
    self.timer = nil;
}

@end
