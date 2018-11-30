//
//  MPMLoginViewController.h
//  MPMAtendence
//  登录页
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPMAttendanceDelegate <NSObject>

/** 考勤首页点击返回，如果在使用考勤的时候Token过期了，会回传tokenExpire = YES，否则正常返回的时候会回传tokenExpire = NO */
- (void)attendanceBackWithTokenExpire:(BOOL)tokenExpire;

@end

@interface MPMLoginViewController : UIViewController

- (instancetype)initWithToken:(NSString *)token
                       userId:(NSString *)userId
                  companyCode:(NSString *)companyCode;

@property (nonatomic, weak) id<MPMAttendanceDelegate> delegate;

@end
