//
//  MPMLoginViewController.h
//  MPMAtendence
//  登录页
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPMAttendanceDelegate <NSObject>

/** 考勤首页点击返回，会返回token、refreshToken、expiresIn：因为如果token是在考勤里面里面失效的，会做刷新token的操作 */
- (void)attendanceDidCompleteWithToken:(NSString *)token refreshToken:(NSString *)refreshToken expiresIn:(NSString *)expiresIn;

@end

@interface MPMLoginViewController : UIViewController

- (instancetype)initWithToken:(NSString *)token
                 refreshToken:(NSString *)refreshToken
                    expiresIn:(NSString *)expiresIn
                       userId:(NSString *)userId
                  companyCode:(NSString *)companyCode;

@property (nonatomic, weak) id<MPMAttendanceDelegate> delegate;

@end
