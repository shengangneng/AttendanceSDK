//
//  MPMTaskContentView.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/27.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMTaskContentView.h"
#import "MPMButton.h"
#import "MPMProcessTaskModel.h"
#import "MPMTaskApplyersScrollView.h"
#import "MPMSelectDepartmentViewController.h"
#import "MPMDepartment.h"
#import "MPMDepartEmployeeHelper.h"
#import "MPMOauthUser.h"
#import "MPMCommomTool.h"

#define kDecisionKeyPath    @"decision"

typedef NS_ENUM(NSInteger, ApplyWay) {
    kApplyWayOfAnyOneCanPass,   /** 任一审核即可通过 */
    kApplyWayOfAllMustPass      /** 所有人通过方可通过 */
};

@interface MPMTaskContentView () <UITextFieldDelegate, MPMTaskApplyersDelegate>

@property (nonatomic, copy) NSString *name;         /** 节点名称 */
@property (nonatomic, copy) NSString *decision;     /** 1一人通过即可继续、2全部通过才能继续 */
@property (nonatomic, copy) NSArray *participants;  /** 记录参与人 */

@end

@implementation MPMTaskContentView

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
    self.nameTextField.delegate = self;
    self.checkButton1.tag = kApplyWayOfAnyOneCanPass;
    self.checkButton2.tag = kApplyWayOfAllMustPass;
    [self addObserver:self forKeyPath:kDecisionKeyPath options:NSKeyValueObservingOptionNew context:nil];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack:)]];
    [self.addApplyerButton addTarget:self action:@selector(addApplyer:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancel addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.save addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [self.checkButton1 addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
    [self.checkButton2 addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (change[NSKeyValueChangeNewKey] && ![change[NSKeyValueChangeNewKey] isKindOfClass:[NSNull class]]) {
        NSString *value = change[NSKeyValueChangeNewKey];
        if ([kDecisionKeyPath isEqualToString:keyPath]) {
            if (value.integerValue == 1) {
                self.checkButton1.selected = YES;
                self.checkButton2.selected = NO;
            } else if (value.integerValue == 2) {
                self.checkButton1.selected = NO;
                self.checkButton2.selected = YES;
            } else {
                self.checkButton1.selected = NO;
                self.checkButton2.selected = NO;
            }
        }
    }
}

- (void)dealloc {
    DLog(@"dealloc  %@",self);
    [self removeObserver:self forKeyPath:kDecisionKeyPath];
}

- (void)setupSubViews {
    [self addSubview:self.flagImageView];
    [self addSubview:self.flagNameLabel];
    [self addSubview:self.starImageView];
    [self addSubview:self.nameLable];
    [self addSubview:self.nameTextField];
    [self addSubview:self.line1];
    
    [self addSubview:self.applyerLabel];
    [self addSubview:self.addApplyerButton];
    [self addSubview:self.applyersView];
    [self addSubview:self.line2];
    
    [self addSubview:self.checkButton1];
    [self addSubview:self.checkButton2];
    [self addSubview:self.checkReason1];
    [self addSubview:self.checkReason2];
    [self addSubview:self.cancel];
    [self addSubview:self.save];
}

- (void)setupConstraints {
    [self.flagImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@77);
        make.height.equalTo(@34.5);
        make.leading.equalTo(self.mpm_leading).offset(-6.5);
        make.top.equalTo(self.mpm_top).offset(10);
    }];
    [self.flagNameLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.flagImageView.mpm_top).offset(4);
        make.leading.equalTo(self.flagImageView.mpm_leading).offset(19.5);
        make.trailing.equalTo(self.flagImageView.mpm_trailing);
        make.bottom.equalTo(self.flagImageView.mpm_bottom);
    }];
    [self.starImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.equalTo(@5.5);
        make.height.equalTo(@6);
        make.trailing.equalTo(self.nameLable.mpm_leading).offset(-2);
        make.centerY.equalTo(self.nameLable.mpm_centerY);
    }];
    [self.nameLable mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.flagNameLabel.mpm_leading);
        make.top.equalTo(self.flagImageView.mpm_bottom).offset(10);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    [self.nameTextField mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.nameLable.mpm_trailing);
        make.top.bottom.equalTo(self.nameLable);
        make.trailing.equalTo(self.mpm_trailing).offset(-13);
    }];
    [self.line1 mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(10);
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
        make.height.equalTo(@1);
        make.top.equalTo(self.nameTextField.mpm_bottom).offset(10);
    }];
    [self.applyerLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(13);
        make.top.equalTo(self.line1.mpm_bottom).offset(10);
        make.height.equalTo(@30);
    }];
    [self.addApplyerButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.equalTo(self.mpm_trailing).offset(-20);
        make.height.width.equalTo(@30);
        make.centerY.equalTo(self.applyerLabel.mpm_centerY);
    }];
    [self.applyersView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.applyerLabel.mpm_bottom).offset(5);
        make.height.equalTo(@63);
    }];
    [self.line2 mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(10);
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
        make.height.equalTo(@1);
        make.top.equalTo(self.applyersView.mpm_bottom).offset(5);
    }];
    [self.checkButton1 mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.leading.equalTo(self.mpm_leading).offset(20);
        make.top.equalTo(self.line2.mpm_bottom).offset(20);
    }];
    [self.checkButton2 mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.leading.equalTo(self.mpm_leading).offset(20);
        make.top.equalTo(self.checkButton1.mpm_bottom).offset(20);
    }];
    [self.checkReason1 mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.checkButton1.mpm_trailing).offset(10);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.checkButton1.mpm_centerY);
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
    }];
    [self.checkReason2 mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.checkButton2.mpm_trailing).offset(10);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.checkButton2.mpm_centerY);
        make.trailing.equalTo(self.mpm_trailing).offset(-10);
    }];
    [self.cancel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.mpm_leading).offset(20);
        make.bottom.equalTo(self.mpm_bottom).offset(-20);
        make.top.equalTo(self.checkReason2.mpm_bottom).offset(20);
    }];
    [self.save mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.equalTo(self.mpm_trailing).offset(-20);
        make.bottom.equalTo(self.mpm_bottom).offset(-20);
        make.height.equalTo(self.cancel);
        make.width.equalTo(self.cancel.mpm_width);
        make.leading.equalTo(self.cancel.mpm_trailing).offset(20);
    }];
}

- (void)setModel:(MPMProcessTaskModel *)model {
    if (!model) {
        model = [[MPMProcessTaskModel alloc] init];
    }
    if (!model.config) {
        model.config = [[MPMProcessTaskConfig alloc] init];
    }
    self.applyersView.participants = self.participants = model.config.participants;
    self.decision = model.config.decision ? model.config.decision : @"1";
    self.nameTextField.text = model.name;
    _model = model;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([MPMCommomTool textViewOrTextFieldHasEmoji:textField]) {
        return NO;
    }
    return YES;
}

#pragma mark - Target Action
- (void)addApplyer:(UIButton *)sender {
    // 跳入多选人员页面（只能选择人员）
    
    [[MPMDepartEmployeeHelper shareInstance].employees removeAllObjects];
    for (int i = 0; i < self.applyersView.participants.count; i++) {
        MPMProcessPeople *people = self.applyersView.participants[i];
        MPMDepartment *emp = [[MPMDepartment alloc] init];
        emp.isHuman = YES;
        emp.name = people.userName;
        emp.mpm_id = people.userId;
        [[MPMDepartEmployeeHelper shareInstance].employees addObject:emp];
    }
    if (self.model.limitParticipants && self.model.limitParticipants.count > 0) {
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:self.model.limitParticipants.count];
        for (int i = 0; i < self.model.limitParticipants.count; i++) {
            MPMProcessPeople *people = self.model.limitParticipants[i];
            MPMDepartment *emp = [[MPMDepartment alloc] init];
            emp.isHuman = YES;
            emp.name = people.userName;
            emp.mpm_id = people.userId;
            [temp addObject:emp];
        }
        [MPMDepartEmployeeHelper shareInstance].limitEmployees = temp.copy;
        [MPMDepartEmployeeHelper shareInstance].limitEmployeeMessage = self.model.limitAlertMessage;
    }
    MPMSelectDepartmentViewController *depart = [[MPMSelectDepartmentViewController alloc] initWithModel:nil headerButtonTitles:[NSMutableArray arrayWithObject:kIsNilString([MPMOauthUser shareOauthUser].shortName) ? @"部门" : [MPMOauthUser shareOauthUser].shortName] selectionType:kSelectionTypeOnlyEmployee comfirmBlock:nil];
    
    __weak typeof(self) weakself = self;
    depart.sureSelectBlock = ^(NSArray<MPMDepartment *> *departments, NSArray<MPMDepartment *> *employees) {
        // 这里只回传人员数据
        __strong typeof(weakself) strongself = weakself;
        NSMutableArray *temp = [NSMutableArray arrayWithCapacity:employees.count];
        for (int i = 0; i < employees.count; i++) {
            MPMDepartment *emp = employees[i];
            MPMProcessPeople *peo = [[MPMProcessPeople alloc] init];
            peo.userName = emp.name;
            peo.userId = emp.mpm_id;
            [temp addObject:peo];
        }
        strongself.applyersView.participants = strongself.participants = temp.copy;
        if (strongself.delegate && [strongself.delegate respondsToSelector:@selector(taskContentViewDidChangePeople:canChangeDecition:)]) {
            BOOL hasPeople = (strongself.participants.count != 0);
            BOOL canChangeDecition = (strongself.model.limitParticipants.count == 0);
            [strongself.delegate taskContentViewDidChangePeople:hasPeople canChangeDecition:canChangeDecition];
        }
    };
    self.destinyVC.hidesBottomBarWhenPushed = YES;
    [self.destinyVC.navigationController pushViewController:depart animated:YES];
}

- (void)taskApplyersDidDeleteParticipants:(NSArray *)participants {
    self.participants = participants;
    if (participants.count == 0 && self.delegate && [self.delegate respondsToSelector:@selector(taskContentViewDidChangePeople:canChangeDecition:)]) {
        BOOL hasPeople = (self.participants.count != 0);
        BOOL canChangeDecition = (self.model.limitParticipants.count <= 1);
        [self.delegate taskContentViewDidChangePeople:hasPeople canChangeDecition:canChangeDecition];
    }
}

- (void)cancel:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskContentViewDidCancel)]) {
        [self.delegate taskContentViewDidCancel];
    }
}

- (void)save:(UIButton *)sender {
    if (kIsNilString(self.nameTextField.text)) {
        __weak typeof(self) weakself = self;
        [self.destinyVC showAlertControllerToLogoutWithMessage:@"请输入节点名称" sureAction:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakself) strongself = weakself;
            [strongself.nameTextField becomeFirstResponder];
        } needCancleButton:NO];
        return;
    }
    if (kIsNilString(self.decision)) {
        [self.destinyVC showAlertControllerToLogoutWithMessage:@"请选择审批方式" sureAction:nil needCancleButton:NO];
        return;
    }
    self.model.name = self.nameTextField.text;
    self.model.config.decision = self.decision;
    self.model.config.participants = self.applyersView.participants;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(taskContentViewDidSaveWithData:)]) {
        [self.delegate taskContentViewDidSaveWithData:self.model];
    }
}

/** 任一、全部的选择框 */
- (void)check:(UIButton *)sender {
    if (kApplyWayOfAnyOneCanPass == sender.tag) {
        self.decision = @"1";
    } else if (kApplyWayOfAllMustPass == sender.tag) {
        self.decision = @"2";
    }
}

#pragma mark - Gesture
- (void)tapBack:(UITapGestureRecognizer *)gesture {
    [self.nameTextField resignFirstResponder];
}

#pragma mark - Lazy Init

- (UIImageView *)flagImageView {
    if (!_flagImageView) {
        _flagImageView = [[UIImageView alloc] init];
        _flagImageView.image = ImageName(@"setting_node");
    }
    return _flagImageView;
}
- (UILabel *)flagNameLabel {
    if (!_flagNameLabel) {
        _flagNameLabel = [[UILabel alloc] init];
        _flagNameLabel.textColor = kWhiteColor;
        _flagNameLabel.textAlignment = NSTextAlignmentLeft;
        _flagNameLabel.text = @"节点1";
        _flagNameLabel.font = SystemFont(15);
    }
    return _flagNameLabel;
}

- (UIImageView *)starImageView {
    if (!_starImageView) {
        _starImageView = [[UIImageView alloc] initWithImage:ImageName(@"attendence_mandatory")];
    }
    return _starImageView;
}

- (UILabel *)nameLable {
    if (!_nameLable) {
        _nameLable = [[UILabel alloc] init];
        _nameLable.textColor = kBlackColor;
        _nameLable.textAlignment = NSTextAlignmentLeft;
        _nameLable.text = @"节点名称:";
        _nameLable.font = SystemFont(15);
    }
    return _nameLable;
}
- (UITextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] init];
        _nameTextField.returnKeyType = UIReturnKeyDone;
        _nameTextField.textColor = kBlackColor;
        _nameTextField.textAlignment = NSTextAlignmentLeft;
        _nameTextField.font = SystemFont(15);
        _nameTextField.placeholder = @"请输入节点名称";
    }
    return _nameTextField;
}
- (UIView *)line1 {
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = kSeperateColor;
    }
    return _line1;
}
- (UILabel *)applyerLabel {
    if (!_applyerLabel) {
        _applyerLabel = [[UILabel alloc] init];
        [_applyerLabel sizeToFit];
        _applyerLabel.textColor = kBlackColor;
        _applyerLabel.textAlignment = NSTextAlignmentLeft;
        _applyerLabel.text = @"审批人";
        _applyerLabel.font = SystemFont(15);
    }
    return _applyerLabel;
}
- (UIButton *)addApplyerButton {
    if (!_addApplyerButton) {
        _addApplyerButton = [MPMButton imageButtonWithImage:ImageName(@"setting_addpersonnel") hImage:ImageName(@"setting_addpersonnel")];
    }
    return _addApplyerButton;
}
- (MPMTaskApplyersScrollView *)applyersView {
    if (!_applyersView) {
        _applyersView = [[MPMTaskApplyersScrollView alloc] init];
        _applyersView.delegate = self;
        _applyersView.backgroundColor = kWhiteColor;
    }
    return _applyersView;
}
- (UIView *)line2 {
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = kSeperateColor;
    }
    return _line2;
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
- (UIButton *)cancel {
    if (!_cancel) {
        _cancel = [MPMButton titleButtonWithTitle:@"取消" nTitleColor:kMainBlueColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_default_reset") hImage:ImageName(@"approval_but_default_reset")];
    }
    return _cancel;
}
- (UIButton *)save {
    if (!_save) {
        _save = [MPMButton titleButtonWithTitle:@"保存" nTitleColor:kWhiteColor hTitleColor:kMainLightGray nBGImage:ImageName(@"approval_but_complete") hImage:ImageName(@"approval_but_complete")];
    }
    return _save;
}

@end
