//
//  MPMTaskEditView.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMTaskEditView.h"
#import "MPMProcessTaskModel.h"
#import "MPMBaseViewController.h"
#import "MPMTaskApplyersScrollView.h"

typedef void(^CompleteBlock)(MPMProcessTaskModel *);

#define kTaskAnimateDuration 0.5

@interface MPMTaskEditView () <MPMTaskContentViewDelegate>

@property (nonatomic, copy) CompleteBlock completeBlock;

@end

@implementation MPMTaskEditView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)setupAttributes {
    self.taskContentView.delegate = self;
}

- (void)setupSubViews {
    [self addSubview:self.taskContentView];
}

- (void)setupConstraints {
    [self.taskContentView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(20);
        make.trailing.equalTo(self.mpm_trailing).offset(-20);
        make.height.equalTo(@370.5);
        make.centerY.equalTo(self.mpm_centerY);
    }];
}

- (void)dealloc {
    DLog(@"dealloc  %@",self);
}

#pragma mark - Private Method
/** 根据是否有审批人来修改视图的约束 */
- (void)updateViewConstaintsWithHasPeople:(BOOL)hasPeople canChangeDecition:(BOOL)canChangeDecition {
    if (hasPeople) {
        [UIView animateWithDuration:0.2 animations:^{
            if (canChangeDecition) {
                [self.taskContentView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                    make.leading.equalTo(self.mpm_leading).offset(20);
                    make.trailing.equalTo(self.mpm_trailing).offset(-20);
                    make.height.equalTo(@375.5);
                    make.centerY.equalTo(self.mpm_centerY);
                }];
                [self.taskContentView.applyersView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                    make.leading.trailing.equalTo(self.taskContentView);
                    make.top.equalTo(self.taskContentView.applyerLabel.mpm_bottom).offset(5);
                    make.height.equalTo(@63);
                }];
                [self.taskContentView.checkButton1 mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                    make.width.height.equalTo(@20);
                    make.leading.equalTo(self.taskContentView.mpm_leading).offset(20);
                    make.top.equalTo(self.taskContentView.line2.mpm_bottom).offset(20);
                }];
                [self.taskContentView.checkButton2 mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                    make.width.height.equalTo(@20);
                    make.leading.equalTo(self.taskContentView.mpm_leading).offset(20);
                    make.top.equalTo(self.taskContentView.checkButton1.mpm_bottom).offset(20);
                }];
                [self.taskContentView.checkReason1 mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                    make.leading.equalTo(self.taskContentView.checkButton1.mpm_trailing).offset(10);
                    make.height.equalTo(@30);
                    make.centerY.equalTo(self.taskContentView.checkButton1.mpm_centerY);
                    make.trailing.equalTo(self.taskContentView.mpm_trailing).offset(-10);
                }];
                [self.taskContentView.checkReason2 mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                    make.leading.equalTo(self.taskContentView.checkButton2.mpm_trailing).offset(10);
                    make.height.equalTo(@30);
                    make.centerY.equalTo(self.taskContentView.checkButton2.mpm_centerY);
                    make.trailing.equalTo(self.taskContentView.mpm_trailing).offset(-10);
                }];
            } else {
                [self.taskContentView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                    make.leading.equalTo(self.mpm_leading).offset(20);
                    make.trailing.equalTo(self.mpm_trailing).offset(-20);
                    make.height.equalTo(@295.5);
                    make.centerY.equalTo(self.mpm_centerY);
                }];
                [self.taskContentView.applyersView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                    make.leading.trailing.equalTo(self.taskContentView);
                    make.top.equalTo(self.taskContentView.applyerLabel.mpm_bottom).offset(5);
                    make.height.equalTo(@63);
                }];
                [self.taskContentView.checkButton1 mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                    make.width.equalTo(@20);
                    make.height.equalTo(@0);
                    make.leading.equalTo(self.taskContentView.mpm_leading).offset(20);
                    make.top.equalTo(self.taskContentView.line2.mpm_bottom).offset(0);
                }];
                [self.taskContentView.checkButton2 mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                    make.width.equalTo(@20);
                    make.height.equalTo(@0);
                    make.leading.equalTo(self.taskContentView.mpm_leading).offset(20);
                    make.top.equalTo(self.taskContentView.checkButton1.mpm_bottom).offset(0);
                }];
                [self.taskContentView.checkReason1 mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                    make.leading.equalTo(self.taskContentView.checkButton1.mpm_trailing).offset(10);
                    make.height.equalTo(@0);
                    make.centerY.equalTo(self.taskContentView.checkButton1.mpm_centerY);
                    make.trailing.equalTo(self.taskContentView.mpm_trailing).offset(-10);
                }];
                [self.taskContentView.checkReason2 mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                    make.leading.equalTo(self.taskContentView.checkButton2.mpm_trailing).offset(10);
                    make.height.equalTo(@0);
                    make.centerY.equalTo(self.taskContentView.checkButton2.mpm_centerY);
                    make.trailing.equalTo(self.taskContentView.mpm_trailing).offset(-10);
                }];
            }
            [self layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            [self.taskContentView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                make.leading.equalTo(self.mpm_leading).offset(20);
                make.trailing.equalTo(self.mpm_trailing).offset(-20);
                make.height.equalTo(@232.5);
                make.centerY.equalTo(self.mpm_centerY);
            }];
            [self.taskContentView.applyersView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                make.leading.trailing.equalTo(self);
                make.top.equalTo(self.taskContentView.applyerLabel.mpm_bottom).offset(5);
                make.height.equalTo(@0);
            }];
            [self.taskContentView.checkButton1 mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                make.width.height.equalTo(@0);
                make.leading.equalTo(self.taskContentView.mpm_leading).offset(20);
                make.top.equalTo(self.taskContentView.line2.mpm_bottom).offset(0);
            }];
            [self.taskContentView.checkButton2 mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                make.width.height.equalTo(@0);
                make.leading.equalTo(self.taskContentView.mpm_leading).offset(20);
                make.top.equalTo(self.taskContentView.checkButton1.mpm_bottom).offset(0);
            }];
            [self.taskContentView.checkReason1 mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                make.leading.equalTo(self.taskContentView.checkButton1.mpm_trailing).offset(10);
                make.height.equalTo(@0);
                make.centerY.equalTo(self.taskContentView.checkButton1.mpm_centerY);
                make.trailing.equalTo(self.taskContentView.mpm_trailing).offset(-10);
            }];
            [self.taskContentView.checkReason2 mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                make.leading.equalTo(self.taskContentView.checkButton2.mpm_trailing).offset(10);
                make.height.equalTo(@0);
                make.centerY.equalTo(self.taskContentView.checkButton2.mpm_centerY);
                make.trailing.equalTo(self.taskContentView.mpm_trailing).offset(-10);
            }];
            [self layoutIfNeeded];
        }];
    }
}

#pragma mark - MPMTaskContentViewDelegate
- (void)taskContentViewDidCancel {
    [self dismiss];
}

- (void)taskContentViewDidSaveWithData:(MPMProcessTaskModel *)model {
    if (self.completeBlock) {
        self.completeBlock(model);
    }
}

- (void)taskContentViewDidChangePeople:(BOOL)hasPeople canChangeDecition:(BOOL)canChangeDecition {
    [self updateViewConstaintsWithHasPeople:hasPeople canChangeDecition:canChangeDecition];
}

#pragma mark - Public Method

- (void)showWithModel:(MPMProcessTaskModel *)model destinyVC:(MPMBaseViewController *)destinyVC completeBlock:(void(^)(MPMProcessTaskModel *))completeBlock {
    self.completeBlock = completeBlock;
    self.taskContentView.destinyVC = destinyVC;
    self.taskContentView.model = model;
    if (!model || model.config.participants.count == 0) {
        [self updateViewConstaintsWithHasPeople:NO canChangeDecition:NO];
    } else {
        if (model.limitParticipants.count == 0) {
            // 如果有限制选择人，则说明之前已经有选了的人和决定的审批方式，则不能更改
            [self updateViewConstaintsWithHasPeople:YES canChangeDecition:YES];
        } else {
            [self updateViewConstaintsWithHasPeople:YES canChangeDecition:YES];
        }
    }
    
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.alpha = 0.2;
    [destinyVC.view addSubview:self];
    [self show];
}

- (void)show {
    [UIView animateKeyframesWithDuration:kTaskAnimateDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeDiscrete animations:^{
        self.alpha = 1.0;
        self.taskContentView.alpha = 1.0;
    } completion:nil];
}

- (void)dismiss {
    [UIView animateKeyframesWithDuration:kTaskAnimateDuration delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.taskContentView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Lazy Init
- (MPMTaskContentView *)taskContentView {
    if (!_taskContentView) {
        _taskContentView = [[MPMTaskContentView alloc] init];
        _taskContentView.layer.cornerRadius = 5;
        _taskContentView.backgroundColor = kWhiteColor;
        _taskContentView.alpha = 0;
    }
    return _taskContentView;
}
@end
