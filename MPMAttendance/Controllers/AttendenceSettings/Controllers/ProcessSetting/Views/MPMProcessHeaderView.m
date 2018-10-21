//
//  MPMProcessHeaderView.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/29.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMProcessHeaderView.h"
#import "MPMButton.h"
#import "MPMAttendanceHeader.h"

@implementation MPMProcessHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

#pragma Target Action
/** 预览申请模板 */
- (void)template:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerSeeTemplate)]) {
        [self.delegate headerSeeTemplate];
    }
}

/** 添加节点 */
- (void)addNode:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerAddNode)]) {
        [self.delegate headerAddNode];
    }
}

/** 修改“终审加签”Switch */
- (void)switchChange:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerChangeSwitch:)]) {
        [self.delegate headerChangeSwitch:sender];
    }
}

- (void)setupAttributes {
    [self.templateButton addTarget:self action:@selector(template:) forControlEvents:UIControlEventTouchUpInside];
    [self.addSignSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    [self.addNodeButton addTarget:self action:@selector(addNode:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.templateButton];
    [self.templateButton addSubview:self.templateLabel];
    [self addSubview:self.addSignView];
    [self.addSignView addSubview:self.addSignLabel];
    [self.addSignView addSubview:self.addSignSwitch];
    [self addSubview:self.addNodeHeaderLabel];
    [self addSubview:self.addNodeView];
    [self.addNodeView addSubview:self.addNodeTitleLabel];
    [self.addNodeView addSubview:self.addNodeButton];
}

- (void)setupConstraints {
    [self.templateButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.equalTo(@30);
        make.top.leading.trailing.equalTo(self);
    }];
    [self.templateLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.templateButton.mpm_leading).offset(15);
        make.top.bottom.equalTo(self.templateButton);
    }];
    [self.addSignView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.equalTo(@(kTableViewHeight));
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.templateButton.mpm_bottom);
    }];
    [self.addSignLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.addSignView.mpm_leading).offset(15);
        make.top.bottom.equalTo(self.addSignView);
    }];
    [self.addSignSwitch mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.equalTo(@35);
        make.trailing.equalTo(self.addSignView.mpm_trailing).offset(-15);
        make.centerY.equalTo(self.addSignView.mpm_centerY);
    }];
    [self.addNodeHeaderLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.trailing.equalTo(self);
        make.leading.equalTo(self.addSignView.mpm_leading).offset(15);
        make.height.equalTo(@30);
        make.top.equalTo(self.addSignView.mpm_bottom);
    }];
    [self.addNodeView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.equalTo(@(kTableViewHeight));
        make.leading.trailing.equalTo(self);
        make.top.equalTo(self.addNodeHeaderLabel.mpm_bottom);
    }];
    [self.addNodeTitleLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.equalTo(self.addNodeView.mpm_leading).offset(15);
        make.top.bottom.equalTo(self.addNodeView);
    }];
    [self.addNodeButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.height.width.equalTo(@30);
        make.centerY.equalTo(self.addNodeView.mpm_centerY);
        make.trailing.equalTo(self.addNodeView.mpm_trailing).offset(-15);
    }];
}

#pragma mark - Lazy Init
- (UILabel *)templateLabel {
    if (!_templateLabel) {
        _templateLabel = [[UILabel alloc] init];
        [_templateLabel sizeToFit];
        _templateLabel.text = @"预览申请模板";
        _templateLabel.font = SystemFont(15);
        _templateLabel.textAlignment = NSTextAlignmentLeft;
        _templateLabel.textColor = kMainBlueColor;
    }
    return _templateLabel;
}

- (UIButton *)templateButton {
    if (!_templateButton) {
        _templateButton = [[UIButton alloc] init];
    }
    return _templateButton;
}
- (UIView *)addSignView {
    if (!_addSignView) {
        _addSignView = [[UIView alloc] init];
        _addSignView.backgroundColor = kWhiteColor;
    }
    return _addSignView;
}
- (UILabel *)addSignLabel {
    if (!_addSignLabel) {
        _addSignLabel = [[UILabel alloc] init];
        [_addSignLabel sizeToFit];
        _addSignLabel.text = @"终审加签";
        _addSignLabel.font = SystemFont(17);
        _addSignLabel.textAlignment = NSTextAlignmentLeft;
        _addSignLabel.textColor = kBlackColor;
    }
    return _addSignLabel;
}
- (UISwitch *)addSignSwitch {
    if (!_addSignSwitch) {
        _addSignSwitch = [[UISwitch alloc] init];
        [_addSignSwitch sizeToFit];
        _addSignSwitch.onTintColor = kMainBlueColor;
    }
    return _addSignSwitch;
}
- (UILabel *)addNodeHeaderLabel {
    if (!_addNodeHeaderLabel) {
        _addNodeHeaderLabel = [[UILabel alloc] init];
        _addNodeHeaderLabel.text = @"最后一级审批人有权向下继续增加审批人";
        _addNodeHeaderLabel.font = SystemFont(15);
        _addNodeHeaderLabel.textAlignment = NSTextAlignmentLeft;
        _addNodeHeaderLabel.textColor = kMainLightGray;
    }
    return _addNodeHeaderLabel;
}
- (UIView *)addNodeView {
    if (!_addNodeView) {
        _addNodeView = [[UIView alloc] init];
        _addNodeView.backgroundColor = kWhiteColor;
    }
    return _addNodeView;
}
- (UILabel *)addNodeTitleLabel {
    if (!_addNodeTitleLabel) {
        _addNodeTitleLabel = [[UILabel alloc] init];
        [_addNodeTitleLabel sizeToFit];
        _addNodeTitleLabel.text = @"添加节点";
        _addNodeTitleLabel.font = SystemFont(17);
        _addNodeTitleLabel.textAlignment = NSTextAlignmentLeft;
        _addNodeTitleLabel.textColor = kBlackColor;
    }
    return _addNodeTitleLabel;
}
- (UIButton *)addNodeButton {
    if (!_addNodeButton) {
        _addNodeButton = [MPMButton imageButtonWithImage:ImageName(@"setting_addpersonnel") hImage:ImageName(@"setting_addpersonnel")];
    }
    return _addNodeButton;
}

@end
