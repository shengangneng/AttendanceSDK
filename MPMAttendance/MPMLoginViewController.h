//
//  MPMLoginViewController.h
//  MPMAtendence
//  登录页
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMLoginViewController : UIViewController

- (void)autoLogin;/** 仅供 */
- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password companyCode:(NSString *)companyCode;

@end
