//
//  MPMTaskContentView.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/27.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPMDepartment;
@class MPMTaskContentView;
@class MPMProcessTaskModel;
@class MPMTaskApplyersScrollView;
@class MPMBaseViewController;

@protocol MPMTaskContentViewDelegate <NSObject>

- (void)taskContentViewDidCancel;
- (void)taskContentViewDidSaveWithData:(MPMProcessTaskModel *)model;
- (void)taskContentViewDidChangePeople:(BOOL)hasPeople canChangeDecition:(BOOL)canChange;         /** 改变了审批人的选择，需要更新view的约束 */

@end

@interface MPMTaskContentView : UIView

// SubViews
@property (nonatomic, strong) UIImageView *flagImageView;
@property (nonatomic, strong) UILabel *flagNameLabel;
@property (nonatomic, strong) UIImageView *starImageView;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UILabel *applyerLabel;
@property (nonatomic, strong) UIButton *addApplyerButton;
@property (nonatomic, strong) MPMTaskApplyersScrollView *applyersView;
@property (nonatomic, strong) UIButton *checkButton1;
@property (nonatomic, strong) UIButton *checkButton2;
@property (nonatomic, strong) UILabel *checkReason1;
@property (nonatomic, strong) UILabel *checkReason2;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIButton *cancel;
@property (nonatomic, strong) UIButton *save;
// Data
@property (nonatomic, strong) MPMProcessTaskModel *model;
@property (nonatomic, weak) MPMBaseViewController *destinyVC;   /** 记录跳入的ViewController */

@property (nonatomic, weak) id<MPMTaskContentViewDelegate> delegate;

@end
