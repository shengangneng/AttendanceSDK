//
//  MPMClassSettingSelectWeekView.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/28.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMClassSettingSelectWeekView : UIView

- (void)showInViewWithCycle:(NSString *)cycle completeBlock:(void(^)(NSString *cycle))completeBlock;
- (void)dismiss;

@end
