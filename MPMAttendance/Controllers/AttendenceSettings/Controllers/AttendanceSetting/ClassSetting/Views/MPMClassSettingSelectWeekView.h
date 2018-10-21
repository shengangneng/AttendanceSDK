//
//  MPMClassSettingSelectWeekView.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/28.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMClassSettingSelectWeekView : UIView

- (void)showInViewWithCycleArray:(NSArray *)cycleArr completeBlock:(void (^)(NSArray *))completeBlock;
- (void)dismiss;

@end
