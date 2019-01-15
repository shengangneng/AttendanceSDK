//
//  MPMApprovalProcessNodeDealingViewController.m
//  MPMAtendence
//  节点处理-驳回、转交、通过
//  Created by shengangneng on 2018/9/20.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMApprovalProcessNodeDealingViewController.h"
#import "MPMButton.h"
#import "MPMAttendencePickerView.h"
#import "MPMSelectDepartmentViewController.h"
#import "MPMSessionManager.h"
#import "MPMOauthUser.h"
#import "MPMTaskInstGroups.h"
#import "MPMApprovalProcessViewController.h"
#import "MPMProcessTaskModel.h"
#import "MPMRoundPeopleButton.h"
#import "MPMDepartEmployeeHelper.h"

#define kPeopleBtnTag   300

@interface MPMApprovalProcessNodeDealingViewController () <MPMSelectDepartmentViewControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) UIView *dealingView;
@property (nonatomic, strong) UIImageView *dealingStarIcon;
@property (nonatomic, strong) UILabel *dealingLabel;
@property (nonatomic, strong) UIButton *rejectView;
@property (nonatomic, strong) UILabel *rejectLabel;
@property (nonatomic, strong) UIImageView *rejectIndicator;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIView *peopleView;

@property (nonatomic, strong) UIView *checkView;
@property (nonatomic, strong) UIView *checkLine;
@property (nonatomic, strong) UIButton *checkButton1;
@property (nonatomic, strong) UIButton *checkButton2;
@property (nonatomic, strong) UILabel *checkReason1;
@property (nonatomic, strong) UILabel *checkReason2;

// 原因：驳回意见（必填）、转交原因（必填）、通过意见（选填）
@property (nonatomic, strong) UIView *reasonView;
@property (nonatomic, strong) UIImageView *reasonStarIcon;      /** 红色星星 */
@property (nonatomic, strong) UILabel *reasonLabel;             /** 驳回意见、转交原因、通过意见 */
@property (nonatomic, strong) UITextView *reasonTextView;       /** 原因输入框 */
@property (nonatomic, strong) UIButton *textViewClearButton;    /** 快捷删除输入框文字按钮 */
@property (nonatomic, strong) UILabel *reasonLimitNumberLabel;  /** 限制字数 */

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, strong) UIButton *bottomCancelButton;
@property (nonatomic, strong) UIButton *bottomRightButton;

@property (nonatomic, strong) MPMAttendencePickerView *pickerView;

// data
@property (nonatomic, assign) DetailNodeDealingType dealingNodeType;
@property (nonatomic, copy) NSArray *selectedPeople;                /** 选中的人 */
@property (nonatomic, copy) NSArray<MPMTaskInstGroups *> *rejectNodesArray;  /** 驳回节点数组 */
@property (nonatomic, copy) NSString *taskInstId;                   /** 当前单据的处理id */
@property (nonatomic, copy) NSString *targetTaskDefCode;            /** 驳回节点，如果没有选中驳回节点，则不需要传 */
@property (nonatomic, strong) MPMProcessMyMetterModel *model;       /** 详情传入的model */
@property (nonatomic, strong) MPMProcessTaskModel *nextNodeModel;   /** 获取下一级审批节点，如果为空，则说明为最后一级审批节点 */

@property (nonatomic, assign) BOOL needNextApplyer;                 /** 需要下一级审批人 */
@property (nonatomic, strong) UIButton *lastSelectedButton;         /** 记录“任一审批“、”所有审批“按钮 */

@end

@implementation MPMApprovalProcessNodeDealingViewController

- (instancetype)initWithDealingNodeType:(DetailNodeDealingType)dealingNodeType taskInstId:(nonnull NSString *)taskInstId model:(MPMProcessMyMetterModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
        self.dealingNodeType = dealingNodeType;
        self.taskInstId = taskInstId;
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kTableViewBGColor;
    if (kDetailNodeDealingTypeReject == self.dealingNodeType) {
        // 驳回
        self.navigationItem.title = @"驳回";
        self.dealingLabel.text = @"驳回至";
        [self.bottomRightButton setTitle:@"驳回" forState:UIControlStateNormal];
        [self.bottomRightButton setTitle:@"驳回" forState:UIControlStateHighlighted];
        self.reasonLabel.text = @"驳回意见";
        [self getRejectNodes];
    } else if (kDetailNodeDealingTypeTransToOthers == self.dealingNodeType) {
        // 转交
        self.navigationItem.title = @"转交";
        self.dealingLabel.text = @"转交至";
        [self.bottomRightButton setTitle:@"转交" forState:UIControlStateNormal];
        [self.bottomRightButton setTitle:@"转交" forState:UIControlStateHighlighted];
        self.reasonLabel.text = @"转交意见";
    } else if (kDetailNodeDealingTypePass == self.dealingNodeType) {
        // 通过
        self.navigationItem.title = @"通过";
        self.dealingLabel.text = @"提交至";
        [self.bottomRightButton setTitle:@"通过" forState:UIControlStateNormal];
        [self.bottomRightButton setTitle:@"通过" forState:UIControlStateHighlighted];
        self.reasonLabel.text = @"通过意见";
        self.reasonStarIcon.hidden = YES;   // 通过意见可以不填
        [self getNextNode];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[MPMDepartEmployeeHelper shareInstance] clearData];
}

- (void)setupAttributes {
    [super setupAttributes];
    self.view.backgroundColor = kTableViewBGColor;
    [self.rejectView addTarget:self action:@selector(selectRejectNode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack:)]];
    [self setLeftBarButtonWithTitle:@"返回" action:@selector(back:)];
    [self.checkButton1 addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
    [self.checkButton2 addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
    [self.addButton addTarget:self action:@selector(addPeople:) forControlEvents:UIControlEventTouchUpInside];
    [self.textViewClearButton addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomCancelButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomRightButton addTarget:self action:@selector(right:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [super setupSubViews];
    
    [self.view addSubview:self.dealingView];
    [self.dealingView addSubview:self.dealingStarIcon];
    [self.dealingView addSubview:self.dealingLabel];
    
    if (kDetailNodeDealingTypeReject == self.dealingNodeType) {
        self.rejectView.hidden = NO;
        self.addButton.hidden = YES;
    } else if (kDetailNodeDealingTypeTransToOthers == self.dealingNodeType) {
        self.rejectView.hidden = YES;
        self.addButton.hidden = NO;
    } else if (kDetailNodeDealingTypePass == self.dealingNodeType) {
        self.rejectView.hidden = YES;
        self.addButton.hidden = NO;
    }
    
    [self.dealingView addSubview:self.rejectView];
    [self.rejectView addSubview:self.rejectLabel];
    [self.rejectView addSubview:self.rejectIndicator];
    
    [self.dealingView addSubview:self.addButton];
    [self.dealingView addSubview:self.peopleView];
    [self.dealingView addSubview:self.checkView];
    [self.checkView addSubview:self.checkLine];
    [self.checkView addSubview:self.checkButton1];
    [self.checkView addSubview:self.checkButton2];
    [self.checkView addSubview:self.checkReason1];
    [self.checkView addSubview:self.checkReason2];
    
    [self.view addSubview:self.reasonView];
    [self.reasonView addSubview:self.reasonStarIcon];
    [self.reasonView addSubview:self.reasonLabel];
    [self.reasonView addSubview:self.reasonTextView];
    [self.reasonView addSubview:self.textViewClearButton];
    [self.reasonView addSubview:self.reasonLimitNumberLabel];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.bottomLine];
    [self.bottomView addSubview:self.bottomCancelButton];
    [self.bottomView addSubview:self.bottomRightButton];
}

- (void)setupConstraints {
    [super setupConstraints];
    
    [self.dealingView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view.mpm_top).offset(10);
        make.bottom.equalTo(self.checkView.mpm_bottom);
    }];
    [self.dealingStarIcon mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@5.5);
        make.height.equalTo(@6);
        make.leading.equalTo(self.dealingView.mpm_leading).offset(8);
        make.centerY.equalTo(self.dealingLabel.mpm_centerY);
    }];
    [self.dealingLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.dealingStarIcon.mpm_trailing).offset(8);
        make.top.equalTo(self.dealingView.mpm_top).offset(14);
        make.height.equalTo(@22);
        make.width.equalTo(@80);
    }];
    [self.rejectView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.equalTo(@22);
        make.trailing.equalTo(self.dealingView.mpm_trailing);
        make.top.equalTo(self.dealingView.mpm_top).offset(14);
        make.leading.equalTo(self.dealingLabel.mpm_trailing).offset(8);
    }];
    [self.rejectLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.bottom.equalTo(self.rejectView);
        make.trailing.equalTo(self.rejectIndicator.mpm_leading).offset(-8);
        make.leading.equalTo(self.rejectView.mpm_leading);
    }];
    [self.rejectIndicator mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@6.5);
        make.height.equalTo(@11);
        make.centerY.equalTo(self.rejectView.mpm_centerY);
        make.trailing.equalTo(self.rejectView.mpm_trailing).offset(-8);
    }];
    [self.addButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.trailing.equalTo(self.dealingView.mpm_trailing).offset(-8);
        make.top.equalTo(self.dealingView.mpm_top).offset(10);
    }];
    [self.peopleView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.dealingLabel.mpm_bottom).offset(14);
        make.leading.trailing.equalTo(self.dealingView);
    }];
    [self.checkView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.dealingView);
        make.top.equalTo(self.peopleView.mpm_bottom);
        make.bottom.equalTo(self.dealingView.mpm_bottom);
        make.height.equalTo(@0);
    }];
    [self.checkLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.checkView);
        make.height.equalTo(@0.5);
    }];
    [self.checkButton1 mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.leading.equalTo(self.checkView).offset(20);
        make.top.equalTo(self.checkLine.mpm_bottom).offset(20);
    }];
    [self.checkButton2 mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.leading.equalTo(self.checkView.mpm_leading).offset(20);
        make.top.equalTo(self.checkButton1.mpm_bottom).offset(20);
    }];
    [self.checkReason1 mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.checkButton1.mpm_trailing).offset(10);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.checkButton1.mpm_centerY);
        make.trailing.equalTo(self.checkView.mpm_trailing).offset(-10);
    }];
    [self.checkReason2 mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.checkButton2.mpm_trailing).offset(10);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.checkButton2.mpm_centerY);
        make.trailing.equalTo(self.checkView.mpm_trailing).offset(-10);
    }];
    
    [self.reasonView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.dealingView.mpm_bottom).offset(10);
        make.height.equalTo(@95);
    }];
    [self.reasonStarIcon mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@5.5);
        make.height.equalTo(@6);
        make.leading.equalTo(self.reasonView.mpm_leading).offset(8);
        make.centerY.equalTo(self.reasonLabel.mpm_centerY);
    }];
    [self.reasonLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.reasonStarIcon.mpm_trailing).offset(8);
        make.top.equalTo(self.reasonView.mpm_top).offset(14);
        make.height.equalTo(@22);
    }];
    [self.reasonTextView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.reasonView.mpm_top).offset(7);
        make.bottom.equalTo(self.reasonView.mpm_bottom).offset(-7);
        make.trailing.equalTo(self.reasonView.mpm_trailing);
        make.leading.equalTo(self.reasonLabel.mpm_trailing).offset(5);
    }];
    [self.textViewClearButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@(12.5));
        make.centerY.equalTo(self.reasonLimitNumberLabel.mpm_centerY);
        make.trailing.equalTo(self.reasonLimitNumberLabel.mpm_leading).offset(-5);
    }];
    [self.reasonLimitNumberLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.equalTo(self.reasonView.mpm_trailing).offset(-5);
        make.bottom.equalTo(self.reasonTextView.mpm_bottom).offset(-12);
        make.height.equalTo(@22);
    }];
    
    [self.bottomView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@(BottomViewHeight));
    }];
    [self.bottomLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self.bottomView);
        make.height.equalTo(@1);
    }];
    [self.bottomCancelButton mpm_remakeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bottomView.mpm_leading).offset(PX_H(23));
        make.width.equalTo(@((kScreenWidth - PX_H(69))/2));
        make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
    }];
    [self.bottomRightButton mpm_remakeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.bottomCancelButton.mpm_trailing).offset(PX_H(23));
        make.trailing.equalTo(self.bottomView.mpm_trailing).offset(-PX_H(23));
        make.top.equalTo(self.bottomView.mpm_top).offset(BottomViewTopMargin);
        make.bottom.equalTo(self.bottomView.mpm_bottom).offset(-BottomViewBottomMargin);
    }];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString* toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (toBeString.length > 30) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.textViewClearButton.hidden = YES;
    } else {
        self.textViewClearButton.hidden = NO;
    }
    self.reasonLimitNumberLabel.attributedText = [self getAttributeString:[NSString stringWithFormat:@"%ld/30",textView.text.length]];
}

/*
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length > 30) {
        textView.text = [textView.text substringToIndex:30];
    }
    self.reasonLimitNumberLabel.attributedText = [self getAttributeString:[NSString stringWithFormat:@"%ld/30",textView.text.length]];
}
 */

#pragma mark - SelectPeopleDelegate
- (void)departCompleteSelectWithDepartments:(NSArray<MPMDepartment *> *)departments employees:(NSArray<MPMDepartment *> *)employees {
    self.selectedPeople = employees;
}

// 修改了选择人之后，改变视图
- (void)setSelectedPeople:(NSArray *)selectedPeople {
    _selectedPeople = selectedPeople;
    for (UIView *subView in self.peopleView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if (selectedPeople.count > 0) {
        int count = 5;
        int width = 50;
        int margin = (kScreenWidth - width * count) / (count + 1);
        
        MPMViewAttribute *lastAttributes = self.peopleView.mpm_leading;
        for (int i = 0; i < selectedPeople.count; i++) {
            MPMDepartment *depart = selectedPeople[i];
            MPMRoundPeopleButton *btn = [[MPMRoundPeopleButton alloc] init];
            btn.roundPeople.nameLabel.text = depart.name.length > 2 ? [depart.name substringWithRange:NSMakeRange(depart.name.length - 2, 2)] : depart.name;
            btn.nameLabel.text = depart.name;
            btn.deleteIcon.hidden = NO;
            btn.tag = kPeopleBtnTag + i;
            [btn addTarget:self action:@selector(deletePeople:) forControlEvents:UIControlEventTouchUpInside];
            [self.peopleView addSubview:btn];
            [btn mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.width.height.equalTo(@50);
                make.leading.equalTo(lastAttributes).offset(margin);
                make.top.equalTo(self.peopleView.mpm_top).offset(5);
                make.bottom.equalTo(self.peopleView.mpm_bottom).offset(-5);
            }];
            lastAttributes = btn.mpm_trailing;
        }
        if (self.needNextApplyer && selectedPeople.count > 1) {
            // 如果是只有一个人，则无需展示通过方式
            [self.checkView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                make.leading.trailing.equalTo(self.dealingView);
                make.top.equalTo(self.peopleView.mpm_bottom);
                make.bottom.equalTo(self.dealingView.mpm_bottom);
                make.height.equalTo(@100);
            }];
        } else {
            [self.checkView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                make.leading.trailing.equalTo(self.dealingView);
                make.top.equalTo(self.peopleView.mpm_bottom);
                make.bottom.equalTo(self.dealingView.mpm_bottom);
                make.height.equalTo(@0);
            }];
        }
        [self.view layoutIfNeeded];
    } else {
        if (self.needNextApplyer) {
            self.checkButton1.selected = self.checkButton2.selected = NO;
            [self.checkView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                make.leading.trailing.equalTo(self.dealingView);
                make.top.equalTo(self.peopleView.mpm_bottom);
                make.bottom.equalTo(self.dealingView.mpm_bottom);
                make.height.equalTo(@0);
            }];
        }
    }
}

#pragma mark - Target Action
- (void)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/** 转交和通过（下一节点没设置人） */
- (void)addPeople:(UIButton *)sender {
    if (kDetailNodeDealingTypeTransToOthers == self.dealingNodeType) {
        // 转交限制只能选择一个人
        [MPMDepartEmployeeHelper shareInstance].limitEmployeeCount = 1;
        [MPMDepartEmployeeHelper shareInstance].limitEmployeeMessage = @"你选择的转交人已包含在当前审批节点中，请重新选择";
        if (self.config && self.config.participants.count > 0) {
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.config.participants.count];
            for (int i = 0; i < self.config.participants.count; i++) {
                MPMProcessPeople *peo = self.config.participants[i];
                MPMDepartment *dep = [[MPMDepartment alloc] init];
                dep.mpm_id = peo.userId;
                dep.name = peo.userName;
                [temp addObject:dep];
            }
            [MPMDepartEmployeeHelper shareInstance].limitEmployees = temp.copy;
        }
    }
    // 跳入人员选择功能
    [[MPMDepartEmployeeHelper shareInstance].employees removeAllObjects];
    [[MPMDepartEmployeeHelper shareInstance].employees addObjectsFromArray:self.selectedPeople];
    MPMSelectDepartmentViewController *depart = [[MPMSelectDepartmentViewController alloc] initWithModel:nil headerButtonTitles:[NSMutableArray arrayWithObject:kIsNilString([MPMOauthUser shareOauthUser].shortName) ? @"部门" : [MPMOauthUser shareOauthUser].shortName] selectionType:kSelectionTypeOnlyEmployee comfirmBlock:nil];
    depart.delegate = self;
    [self.navigationController pushViewController:depart animated:YES];
}

- (void)tapBack:(UITapGestureRecognizer *)gesture {
    [self.reasonTextView resignFirstResponder];
}

// 点击头像删除人
- (void)deletePeople:(UIButton *)sender {
    NSInteger index = sender.tag - kPeopleBtnTag;
    NSMutableArray *temp = [NSMutableArray arrayWithArray:self.selectedPeople];
    [temp removeObjectAtIndex:index];
    self.selectedPeople = temp.copy;
}

// textview后面的一键删除按钮
- (void)clear:(UIButton *)sender {
    self.reasonTextView.text = @"";
    self.reasonLimitNumberLabel.attributedText = [self getAttributeString:[NSString stringWithFormat:@"%d/30",0]];
    sender.hidden = YES;
}

- (void)check:(UIButton *)sender {
    sender.selected = YES;
    if (self.lastSelectedButton != sender) {
        self.lastSelectedButton.selected = NO;
        self.lastSelectedButton = sender;
    }
}

#pragma mark - Private Method
// 获取所有驳回节点
- (void)getRejectNodes {
    NSString *url = [NSString stringWithFormat:@"%@%@?taskInstId=%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_BACKTASK,self.taskInstId];
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        DLog(@"%@",response);
        if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
            NSArray *object = response[kResponseObjectKey];
            NSMutableArray *temp = [NSMutableArray arrayWithCapacity:object.count];
            for (int i = 0; i < object.count; i++) {
                NSDictionary *dic = object[i];
                MPMTaskInstGroups *group = [[MPMTaskInstGroups alloc] initWithDictionary:dic];
                if (dic[@"participants"] && [dic[@"participants"] isKindOfClass:[NSArray class]]) {
                    NSArray *participants = dic[@"participants"];
                    NSMutableArray *tempPart = [NSMutableArray arrayWithCapacity:participants.count];
                    for (int j = 0; j < participants.count; j++) {
                        NSDictionary *instDic = participants[j];
                        MPMTaskInsts *insts = [[MPMTaskInsts alloc] initWithDictionary:instDic];
                        [tempPart addObject:insts];
                    }
                    group.taskInst = tempPart.copy;
                }
                [temp addObject:group];
            }
            self.rejectNodesArray = temp.copy;
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

// 通过需要调用是否含有下一节点
- (void)getNextNode {
    NSString *url = [NSString stringWithFormat:@"%@%@?processDefCode=%@&taskcode=%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_NEXTTASK,self.model.processDefCode,self.model.taskCode];
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        DLog(@"%@",response);
        if (response[kResponseDataKey] && kRequestSuccess == ((NSString *)response[kResponseDataKey][kCode]).integerValue) {
            
            if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSDictionary class]]) {
                NSDictionary *object = response[kResponseObjectKey];
                self.nextNodeModel = [[MPMProcessTaskModel alloc] initWithDictionary:object];
                if (object[@"config"] && [object[@"config"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *config = object[@"config"];
                    self.nextNodeModel.config = [[MPMProcessTaskConfig alloc] initWithDictionary:config];
                } else {
                    self.nextNodeModel.config = nil;
                }
            }
            
            if (self.nextNodeModel.mpm_id && (!self.nextNodeModel.config || self.nextNodeModel.config.participants.count == 0)) {
                // 如果有节点，但是没有审批人，则需要设置提交至
                self.needNextApplyer = YES;
            } else {
                // 隐藏提交至
                [self.reasonView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                    make.leading.trailing.equalTo(self.view);
                    make.top.equalTo(self.view.mpm_top).offset(10);
                    make.height.equalTo(@95);
                }];
                self.checkButton1.hidden =
                self.checkButton2.hidden =
                self.checkReason1.hidden =
                self.checkReason2.hidden = YES;
                [self.view layoutIfNeeded];
            }
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:error];
    }];
}

/** 验证驳回、转交、通过参数是否正确 */
- (BOOL)validateSubmitData {
    if (kDetailNodeDealingTypeReject == self.dealingNodeType) {
        if (kIsNilString(self.reasonTextView.text)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入驳回意见" sureAction:nil needCancleButton:NO];return NO;
        }
        if (self.reasonTextView.text.length > 30) {
            [self showAlertControllerToLogoutWithMessage:@"驳回意见不能超过30个字，请重新编辑" sureAction:nil needCancleButton:NO];return NO;
        }
    } else if (kDetailNodeDealingTypeTransToOthers == self.dealingNodeType) {
        if (self.selectedPeople.count == 0) {
            [self showAlertControllerToLogoutWithMessage:@"请选择转交人" sureAction:nil needCancleButton:NO];return NO;
        }
        if (kIsNilString(self.reasonTextView.text)) {
            [self showAlertControllerToLogoutWithMessage:@"请输入转交意见" sureAction:nil needCancleButton:NO];return NO;
        }
        if (self.reasonTextView.text.length > 30) {
            [self showAlertControllerToLogoutWithMessage:@"转交意见不能超过30个字，请重新编辑" sureAction:nil needCancleButton:NO];return NO;
        }
    } else if (kDetailNodeDealingTypePass == self.dealingNodeType) {
        // 通过意见可以为空
        if (self.needNextApplyer && 0 == self.selectedPeople.count) {
            [self showAlertControllerToLogoutWithMessage:@"请选择下一级审批人" sureAction:nil needCancleButton:NO];return NO;
        }
        if (self.reasonTextView.text.length > 30) {
            [self showAlertControllerToLogoutWithMessage:@"通过意见不能超过30个字，请重新编辑" sureAction:nil needCancleButton:NO];return NO;
        }
        if (self.needNextApplyer && self.selectedPeople.count > 1 && self.checkButton1.selected == NO && self.checkButton2.selected == NO) {
            [self showAlertControllerToLogoutWithMessage:@"请选择审批人审批通过方式" sureAction:nil needCancleButton:NO];return NO;
        }
    }
    return YES;
}

/** 选择驳回至某个节点 */
- (void)selectRejectNode:(UIButton *)sender {
    if (self.rejectNodesArray.count == 0) {
        [self showAlertControllerToLogoutWithMessage:@"找不到上一级" sureAction:nil needCancleButton:NO];return;
    }
    NSArray *pickerData;
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.rejectNodesArray.count];
    for (int i = 0; i < self.rejectNodesArray.count; i++) {
        MPMTaskInstGroups *inst = self.rejectNodesArray[i];
        [temp addObject:kSafeString(inst.taskName)];
    }
    pickerData = temp.copy;
    // 默认驳回到最靠近的一级
    NSInteger defaultRow = kIsNilString(self.targetTaskDefCode) ? 0 : [pickerData indexOfObject:self.rejectLabel.text];
    [self.pickerView showInView:kAppDelegate.window withPickerData:pickerData selectRow:defaultRow];
    __weak typeof(self) weakself = self;
    self.pickerView.completeSelectBlock = ^(NSString *data) {
        __strong typeof(weakself) strongself = weakself;
        NSInteger index = [pickerData indexOfObject:data];
        if (pickerData.count > 0 && index < pickerData.count) {
            strongself.targetTaskDefCode = ((MPMTaskInstGroups *)strongself.rejectNodesArray[index]).taskCode;
            strongself.rejectLabel.text = data;
        }
    };
}

- (void)right:(UIButton *)sender {
    if (![self validateSubmitData]) {
        return;
    }
    // 驳回、转交、通过
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url;
    NSString *alertMessage;
    if (kDetailNodeDealingTypeReject == self.dealingNodeType) {
        url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_COMPLETETASK];
        params[@"remark"] = self.reasonTextView.text;
        params[@"route"] = @"2";
        if (!kIsNilString(self.targetTaskDefCode)) {
            // 如果没有选中的驳回节点，则不需要传
            params[@"targetTaskDefCode"] = self.targetTaskDefCode;
        }
        params[@"taskInstId"] = self.taskInstId;
        alertMessage = @"驳回";
    } else if (kDetailNodeDealingTypeTransToOthers == self.dealingNodeType) {
        url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_REASSIGN];
        params[@"remark"] = self.reasonTextView.text;
        params[@"taskInstId"] = self.taskInstId;
        NSMutableDictionary *config = [NSMutableDictionary dictionary];
        config[@"decision"] = self.config.decision;
        config[@"groupId"] = self.config.groupId;
        NSMutableArray *participants = [NSMutableArray arrayWithCapacity:self.selectedPeople.count];
        for (int i = 0; i < self.selectedPeople.count; i++) {
            MPMDepartment *peopel = self.selectedPeople[i];
            [participants addObject:@{@"userId":peopel.mpm_id,@"userName":peopel.name}];
        }
        config[@"participants"] = participants;
        params[@"config"] = config;
        alertMessage = @"转交";
    } else if (kDetailNodeDealingTypePass == self.dealingNodeType) {
        url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_WORKFLOW,MPMINTERFACE_APPROVAL_COMPLETETASK];
        params[@"remark"] = self.reasonTextView.text;
        params[@"route"] = @"1";
        params[@"taskInstId"] = self.taskInstId;
        if (self.needNextApplyer) {
            NSMutableDictionary *config = [NSMutableDictionary dictionary];
            config[@"decision"] = self.checkButton1.selected ? @"1" : @"2";
            NSMutableArray *participants = [NSMutableArray arrayWithCapacity:self.selectedPeople.count];
            for (int i = 0; i < self.selectedPeople.count; i++) {
                MPMDepartment *peopel = self.selectedPeople[i];
                [participants addObject:@{@"userId":peopel.mpm_id,@"userName":peopel.name}];
            }
            config[@"participants"] = participants;
            params[@"participantConfig"] = config;
        }
        alertMessage = @"操作";
    }
    
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:YES params:params loadingMessage:@"正在操作" success:^(id response) {
        DLog(@"%@",response);
        if (response && kRequestSuccess == ((NSString *)response[kResponseDataKey][kCode]).integerValue) {
            // 请求成功 - 往回跳两个控制器回到流程审批主页
            __weak typeof(self) weakself = self;
            [self showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"%@成功",alertMessage] sureAction:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakself) strongself = weakself;
                UIViewController *vc = strongself.navigationController.viewControllers[strongself.navigationController.viewControllers.count - 3];
                if (vc && [vc isKindOfClass:[MPMApprovalProcessViewController class]]) {
                    [strongself.navigationController popToViewController:vc animated:YES];
                }
            } needCancleButton:NO];
        } else {
            [self showAlertControllerToLogoutWithMessage:[NSString stringWithFormat:@"%@失败",alertMessage] sureAction:nil needCancleButton:NO];
        }
    } failure:^(NSString *error) {
        DLog(@"%@",error);
        [MPMProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@失败",alertMessage]];
    }];
}

// 通过NSString返回NSAttributeString
- (NSAttributedString *)getAttributeString:(NSString *)str {
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSInteger loca = str.length - 2;
    [AttributedStr addAttribute:NSForegroundColorAttributeName
                          value:kMainLightGray
                          range:NSMakeRange(loca, 2)];
    return AttributedStr;
}

#pragma mark - Lazy Init

- (UIView *)dealingView {
    if (!_dealingView) {
        _dealingView = [[UIView alloc] init];
        _dealingView.backgroundColor = kWhiteColor;
    }
    return _dealingView;
}
- (UIImageView *)dealingStarIcon {
    if (!_dealingStarIcon) {
        _dealingStarIcon = [[UIImageView alloc] init];
        _dealingStarIcon.image = ImageName(@"attendence_mandatory");
    }
    return _dealingStarIcon;
}
- (UILabel *)dealingLabel {
    if (!_dealingLabel) {
        _dealingLabel = [[UILabel alloc] init];
        _dealingLabel.text = @"驳回至";
    }
    return _dealingLabel;
}
- (UIButton *)rejectView {
    if (!_rejectView) {
        _rejectView = [[UIButton alloc] init];
    }
    return _rejectView;
}
- (UILabel *)rejectLabel {
    if (!_rejectLabel) {
        _rejectLabel = [[UILabel alloc] init];
        _rejectLabel.text = @"默认至上一级";
        _rejectLabel.textColor = kMainLightGray;
        _rejectLabel.font = SystemFont(17);
        [_rejectLabel sizeToFit];
        _rejectLabel.textAlignment = NSTextAlignmentRight;
    }
    return _rejectLabel;
}
- (UIImageView *)rejectIndicator {
    if (!_rejectIndicator) {
        _rejectIndicator = [[UIImageView alloc] init];
        _rejectIndicator.image = ImageName(@"statistics_rightenter");
    }
    return _rejectIndicator;
}
- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [MPMButton imageButtonWithImage:ImageName(@"commom_add") hImage:ImageName(@"commom_add")];
    }
    return _addButton;
}
- (UIView *)peopleView {
    if (!_peopleView) {
        _peopleView = [[UIView alloc] init];
    }
    return _peopleView;
}
- (UIView *)checkView {
    if (!_checkView) {
        _checkView = [[UIView alloc] init];
    }
    return _checkView;
}
- (UIView *)checkLine {
    if (!_checkLine) {
        _checkLine = [[UIView alloc] init];
        _checkLine.backgroundColor = kSeperateColor;
    }
    return _checkLine;
}
- (UIButton *)checkButton1 {
    if (!_checkButton1) {
        _checkButton1 = [MPMButton imageButtonWithImage:ImageName(@"setting_progress_uncheck") hImage:ImageName(@"setting_progress_check")];
        [_checkButton1 setImage:ImageName(@"setting_progress_check") forState:UIControlStateSelected];
    }
    return _checkButton1;
}
- (UIButton *)checkButton2 {
    if (!_checkButton2) {
        _checkButton2 = [MPMButton imageButtonWithImage:ImageName(@"setting_progress_uncheck") hImage:ImageName(@"setting_progress_check")];
        [_checkButton2 setImage:ImageName(@"setting_progress_check") forState:UIControlStateSelected];
    }
    return _checkButton2;
}
- (UILabel *)checkReason1 {
    if (!_checkReason1) {
        _checkReason1 = [[UILabel alloc] init];
        _checkReason1.textColor = kBlackColor;
        _checkReason1.textAlignment = NSTextAlignmentLeft;
        _checkReason1.text = @"任一审批人通过，则审批通过";
        _checkReason1.font = SystemFont(15);
    }
    return _checkReason1;
}
- (UILabel *)checkReason2 {
    if (!_checkReason2) {
        _checkReason2 = [[UILabel alloc] init];
        _checkReason2.textColor = kBlackColor;
        _checkReason2.textAlignment = NSTextAlignmentLeft;
        _checkReason2.text = @"需所有审批人通过，则审批通过";
        _checkReason2.font = SystemFont(15);
    }
    return _checkReason2;
}

// 原因：驳回意见（必填）、转交原因（必填）、通过意见（选填）
- (UIView *)reasonView {
    if (!_reasonView) {
        _reasonView = [[UIView alloc] init];
        _reasonView.backgroundColor = kWhiteColor;
    }
    return _reasonView;
}
- (UIImageView *)reasonStarIcon {
    if (!_reasonStarIcon) {
        _reasonStarIcon = [[UIImageView alloc] init];
        _reasonStarIcon.image = ImageName(@"attendence_mandatory");
    }
    return _reasonStarIcon;
}
- (UILabel *)reasonLabel {
    if (!_reasonLabel) {
        _reasonLabel = [[UILabel alloc] init];
        _reasonLabel.text = @"申请原因";
        [_reasonLabel sizeToFit];
        _reasonLabel.textColor = kBlackColor;
        _reasonLabel.textAlignment = NSTextAlignmentLeft;
        _reasonLabel.font = SystemFont(17);
    }
    return _reasonLabel;
}
- (UITextView *)reasonTextView {
    if (!_reasonTextView) {
        _reasonTextView = [[UITextView alloc] init];
        _reasonTextView.delegate = self;
        _reasonTextView.font = SystemFont(17);
        _reasonTextView.textContainer.lineFragmentPadding = 8;
        [_reasonTextView sizeToFit];
    }
    return _reasonTextView;
}
- (UIButton *)textViewClearButton {
    if (!_textViewClearButton) {
        _textViewClearButton = [MPMButton imageButtonWithImage:ImageName(@"approval_delete") hImage:ImageName(@"approval_delete")];
        _textViewClearButton.hidden = YES;
    }
    return _textViewClearButton;
}
- (UILabel *)reasonLimitNumberLabel {
    if (!_reasonLimitNumberLabel) {
        _reasonLimitNumberLabel = [[UILabel alloc] init];
        _reasonLimitNumberLabel.attributedText = [self getAttributeString:@"0/30"];
        [_reasonLimitNumberLabel sizeToFit];
        _reasonLimitNumberLabel.textColor = kBlackColor;
        _reasonLimitNumberLabel.textAlignment = NSTextAlignmentRight;
        _reasonLimitNumberLabel.font = SystemFont(17);
    }
    return _reasonLimitNumberLabel;
}

// bottomView
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = kWhiteColor;
    }
    return _bottomView;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = kSeperateColor;
    }
    return _bottomLine;
}

- (UIButton *)bottomCancelButton {
    if (!_bottomCancelButton) {
        _bottomCancelButton = [MPMButton titleButtonWithTitle:@"取消" nTitleColor:kMainBlueColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_default_reset") hImage:ImageName(@"approval_but_default_reset")];
    }
    return _bottomCancelButton;
}

- (UIButton *)bottomRightButton {
    if (!_bottomRightButton) {
        _bottomRightButton = [MPMButton titleButtonWithTitle:@"提交" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _bottomRightButton;
}

- (MPMAttendencePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[MPMAttendencePickerView alloc] init];
    }
    return _pickerView;
}

@end
