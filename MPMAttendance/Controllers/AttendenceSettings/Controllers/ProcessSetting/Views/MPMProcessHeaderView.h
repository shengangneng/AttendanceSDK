//
//  MPMProcessHeaderView.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/29.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPMProcessHeaderDelegate <NSObject>

- (void)headerSeeTemplate;                  /** 点击预览申请模板 */
- (void)headerChangeSwitch:(UISwitch *)sw;  /** 点击switch */
- (void)headerAddNode;                      /** 点击添加节点 */

@end

@interface MPMProcessHeaderView : UIView

@property (nonatomic, strong) UILabel *templateLabel;
@property (nonatomic, strong) UIButton *templateButton;
@property (nonatomic, strong) UIView *addSignView;
@property (nonatomic, strong) UILabel *addSignLabel;
@property (nonatomic, strong) UISwitch *addSignSwitch;
@property (nonatomic, strong) UILabel *addNodeHeaderLabel;
@property (nonatomic, strong) UIView *addNodeView;
@property (nonatomic, strong) UILabel *addNodeTitleLabel;
@property (nonatomic, strong) UIButton *addNodeButton;

@property (nonatomic, weak) id<MPMProcessHeaderDelegate> delegate;

@end
