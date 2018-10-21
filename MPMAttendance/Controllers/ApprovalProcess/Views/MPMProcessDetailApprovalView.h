//
//  MPMProcessDetailApprovalView.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMRoundPeopleView.h"
@class MPMProcessDetailApprovalTriangleView;

NS_ASSUME_NONNULL_BEGIN

@interface MPMProcessDetailApprovalView : UIView

@property (nonatomic, strong) MPMRoundPeopleView *userIcon;     /** 蓝色头像 */
@property (nonatomic, strong) UILabel *userName;                /** 名字 */
@property (nonatomic, strong) MPMProcessDetailApprovalTriangleView *triangleView;             /** 白色三角形 */
@property (nonatomic, strong) UIImageView *contentImageView;    /** 白色内容背景框 */
@property (nonatomic, strong) UIImageView *approvalStatusImage; /** 审批状态图标 */
@property (nonatomic, strong) UILabel *approvalStatusMessage;   /** 审批状态文字 */
@property (nonatomic, strong) UILabel *approvalTime;            /** 审批时间 */
@property (nonatomic, strong) UILabel *approvalDetailMessage;   /** 审批意见 */

@property (nonatomic, copy) NSString *detailMessage;            /** 审批意见，修改的时候需要改变UI */

- (void)setState:(NSString * _Nonnull)state route:(NSString *)route isApply:(BOOL)apply;

@end

NS_ASSUME_NONNULL_END
