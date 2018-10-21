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
- (void)siderDrawerViewDidCompleteSelected;

@end

@interface MPMSideDrawerView : UIView

@property (nonatomic, weak) id<MPMSideDrawerViewDelegate> delegate;
// 保存选中的属性
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@property (nonatomic, assign) NSInteger pagesize;

/** @param statusTitles 节点状态数组：待办（全部、待处理、驳回的）已办（全部、已通过、已驳回）我的申请（全部、进行中、已完成、已取消）抄送给我（无） */
- (void)showInView:(UIView *)superView maskViewFrame:(CGRect)mFrame drawerViewFrame:(CGRect)dFrame statusTitles:(NSArray *)statusTitles;
- (void)dismiss;
- (void)reset:(UIButton *)sender;   /** 重置数据 */

@end
