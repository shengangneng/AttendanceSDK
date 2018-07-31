//
//  MPMSideDrawerView.h
//  MPMAtendence
//  侧边滑出-抽屉视图
//  Created by gangneng shen on 2018/4/25.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPMSideDrawerView;

@protocol MPMSideDrawerViewDelegate<NSObject>

- (void)siderDrawerViewDidDismiss;
- (void)siderDrawerView:(MPMSideDrawerView *)siderDrawerView didCompleteWithCausationtypeNo:(NSArray *)cNo startDate:(NSString *)sDate endDate:(NSString *)eDate;

@end

@interface MPMSideDrawerView : UIView

@property (nonatomic, weak) id<MPMSideDrawerViewDelegate> delegate;

- (void)showInView:(UIView *)superView maskViewFrame:(CGRect)mFrame drawerViewFrame:(CGRect)dFrame;
- (void)dismiss;
- (void)reset:(UIButton *)sender;   /** 重置数据 */

@end
