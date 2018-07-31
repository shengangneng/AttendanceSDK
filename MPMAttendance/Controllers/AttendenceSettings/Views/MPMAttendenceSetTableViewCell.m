//
//  MPMAttendenceSetTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMAttendenceSetTableViewCell.h"
#import "MPMButton.h"
#import "UIImage+MPMExtention.h"

@implementation MPMAttendenceSetTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
        [self setupConstraints];
    }
    return self;
}

#define kShadowOffset 2
- (void)resetCellWithModel:(MPMAttendenceSettingModel *)model cellHeight:(CGFloat)height {
    // 设置Cell底部的阴影
    self.bottomImageView.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, height - 42.5 - 10 - kShadowOffset/2, kScreenWidth - 20, kShadowOffset)].CGPath;
    
    MASViewAttribute *preAttribute = self.headerImageView.mas_bottom;
    // 范围
    [self.workScopeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(10);
        make.trailing.equalTo(self.bottomImageView.mas_trailing);
        make.top.equalTo(preAttribute).offset(8);
    }];
    if (model.schedulingDepartments.count > 0 || model.schedulingEmplyoees.count > 0) {
        preAttribute = self.workScopeLabel.mas_bottom;
    }
    
    // 班次
    [self.classLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(10);
        make.top.equalTo(preAttribute).offset(8);
        make.trailing.equalTo(self.bottomImageView);
    }];
    if (model.slotTimeDtos.count >= 1) {
        preAttribute = self.classLabel1.mas_bottom;
    }
    [self.classLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(10);
        make.top.equalTo(preAttribute).offset(8);
        make.trailing.equalTo(self.bottomImageView);
    }];
    if (model.slotTimeDtos.count >= 2) {
        preAttribute = self.classLabel2.mas_bottom;
    }
    [self.classLabel3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(10);
        make.top.equalTo(preAttribute).offset(8);
        make.trailing.equalTo(self.bottomImageView);
    }];
    if (model.slotTimeDtos.count >= 3) {
        preAttribute = self.classLabel3.mas_bottom;
    }
    
    // 考勤日期
    [self.workDateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(10);
        make.trailing.equalTo(self.bottomImageView);
        make.top.equalTo(preAttribute).offset(8);
    }];
    if (!kIsNilString(model.cycle)) {
        preAttribute = self.workDateLabel.mas_bottom;
    }
    
    // 地点
    [self.workLocationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(10);
        make.trailing.equalTo(self.bottomImageView);
        make.top.equalTo(self.workDateLabel.mas_bottom).offset(8);
    }];
    if (!kIsNilString(model.address)) {
        preAttribute = self.workLocationLabel.mas_bottom;
    }
    // wifi名称
    [self.workWifiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(11);
        make.trailing.equalTo(self.bottomImageView);
        make.top.equalTo(preAttribute).offset(8);
    }];
}

#pragma mark - Target Action
- (void)edit:(UIButton *)sender {
    if (self.editBlock) {
        self.editBlock();
    }
}

- (void)leftswipe:(UISwipeGestureRecognizer *)gesture {
    if (self.swipeShowBlock) {
        self.swipeShowBlock();
    }
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.headerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(-90);
            make.trailing.equalTo(self.mas_trailing).offset(-100);
            make.top.equalTo(self.mas_top).offset(5);
            make.height.equalTo(@44.5);
        }];
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)rightswipe:(UISwipeGestureRecognizer *)gesture {
    [self dismissSwipeView];
}

- (void)cellTap:(UITapGestureRecognizer *)gesture {
    [self dismissSwipeView];
}

- (void)dismissSwipeView {
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.headerImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(10);
            make.trailing.equalTo(self.mas_trailing).offset(-10);
            make.top.equalTo(self.mas_top).offset(5);
            make.height.equalTo(@44.5);
        }];
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)delete:(UITapGestureRecognizer *)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(attendenceSetTableCellDidDeleteWithModel:)]) {
        [self.delegate attendenceSetTableCellDidDeleteWithModel:self.model];
    }
}

- (void)setupAttributes {
    self.backgroundColor = kTableViewBGColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UISwipeGestureRecognizer *leftswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftswipe:)];
    UISwipeGestureRecognizer *rightswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightswipe:)];
    UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTap:)];
    leftswipe.direction = UISwipeGestureRecognizerDirectionLeft;
    rightswipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:leftswipe];
    [self addGestureRecognizer:rightswipe];
    [self addGestureRecognizer:cellTap];
    [self.headerEditButton addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    [self.swipeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(delete:)]];
}

- (void)setupSubViews {
    [self addSubview:self.bottomImageView];
    [self addSubview:self.headerImageView];
    [self addSubview:self.swipeView];
    [self.headerImageView addSubview:self.headerIconView];
    [self.headerImageView addSubview:self.headerTitleLabel];
    [self.headerImageView addSubview:self.headerEditButton];
    
    // 范围
    [self.bottomImageView addSubview:self.workScopeLabel];
    
    // 班次
    [self.bottomImageView addSubview:self.classLabel1];
    [self.bottomImageView addSubview:self.classLabel2];
    [self.bottomImageView addSubview:self.classLabel3];
    
    // 考勤日期
    [self.bottomImageView addSubview:self.workDateLabel];
    
    // 地点
    [self.bottomImageView addSubview:self.workLocationLabel];
    
    // wifi名称
    [self.bottomImageView addSubview:self.workWifiLabel];
    
    // 左滑才出现的视图
    [self.swipeView addSubview:self.swipeTitleLabel];
}

- (void)setupConstraints {
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(10);
        make.trailing.equalTo(self.mas_trailing).offset(-10);
        make.top.equalTo(self.mas_top).offset(5);
        make.height.equalTo(@44.5);
    }];
    [self.headerIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@22);
        make.height.equalTo(@20.5);
        make.leading.equalTo(self.headerImageView.mas_leading).offset(10);
        make.centerY.equalTo(self.headerImageView.mas_centerY);
    }];
    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20.5);
        make.leading.equalTo(self.headerIconView.mas_trailing).offset(10);
        make.centerY.equalTo(self.headerImageView.mas_centerY);
    }];
    [self.headerEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@19);
        make.height.equalTo(@19.5);
        make.trailing.equalTo(self.headerImageView.mas_trailing).offset(-10);
        make.centerY.equalTo(self.headerImageView.mas_centerY);
    }];
    
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImageView.mas_leading);
        make.trailing.equalTo(self.headerImageView);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(-5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    // 范围
    [self.workScopeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(10);
        make.trailing.equalTo(self.bottomImageView.mas_trailing);
        make.top.equalTo(self.headerImageView.mas_bottom).offset(8);
    }];
    
    // 班次
    [self.classLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(10);
        make.top.equalTo(self.workScopeLabel.mas_bottom).offset(8);
        make.trailing.equalTo(self.bottomImageView);
    }];
    [self.classLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(10);
        make.top.equalTo(self.classLabel1.mas_bottom).offset(8);
        make.trailing.equalTo(self.bottomImageView);
    }];
    [self.classLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(10);
        make.top.equalTo(self.classLabel2.mas_bottom).offset(8);
        make.trailing.equalTo(self.bottomImageView);
    }];
    
    // 考勤日期
    [self.workDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(10);
        make.trailing.equalTo(self.bottomImageView);
        make.top.equalTo(self.classLabel3.mas_bottom).offset(8);
    }];
    
    // 地点
    [self.workLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(10);
        make.trailing.equalTo(self.bottomImageView);
        make.top.equalTo(self.workDateLabel.mas_bottom).offset(8);
    }];
    // wifi名称
    [self.workWifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.bottomImageView.mas_leading).offset(10);
        make.trailing.equalTo(self.bottomImageView);
        make.top.equalTo(self.workLocationLabel.mas_bottom).offset(8);
    }];
    // 左滑视图
    [self.swipeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerImageView.mas_trailing).offset(10);
        make.width.equalTo(@80);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.top.equalTo(self.mas_top).offset(5);
    }];
    [self.swipeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.swipeView.mas_centerX);
        make.centerY.equalTo(self.swipeView.mas_centerY);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
}

#pragma mark - Lazy Init
// 头部视图
- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithImage:ImageName(@"setting_header")];
        _headerImageView.userInteractionEnabled = YES;
    }
    return _headerImageView;
}
- (UIImageView *)headerIconView {
    if (!_headerIconView) {
        _headerIconView = [[UIImageView alloc] initWithImage:ImageName(@"setting_scheduling")];
    }
    return _headerIconView;
}
- (UILabel *)headerTitleLabel {
    if (!_headerTitleLabel) {
        _headerTitleLabel = [[UILabel alloc] init];
        _headerTitleLabel.textColor = kWhiteColor;
        _headerTitleLabel.font = SystemFont(17);
        [_headerTitleLabel sizeToFit];
    }
    return _headerTitleLabel;
}
- (UIButton *)headerEditButton {
    if (!_headerEditButton) {
        _headerEditButton = [MPMButton imageButtonWithImage:ImageName(@"setting_scheduleditor") hImage:ImageName(@"setting_scheduleditor")];
    }
    return _headerEditButton;
}

// 底部视图
- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] initWithImage:ImageName(@"setting_bottom")];
        _bottomImageView.userInteractionEnabled = YES;
        _bottomImageView.layer.masksToBounds = NO;
        _bottomImageView.layer.shadowOffset = CGSizeZero;
        _bottomImageView.layer.shadowRadius = 3;
        _bottomImageView.layer.shadowColor = kMainLightGray.CGColor;
        _bottomImageView.layer.shadowOpacity = 1;
    }
    return _bottomImageView;
}

// 范围
- (UILabel *)workScopeLabel {
    if (!_workScopeLabel) {
        _workScopeLabel = [[UILabel alloc] init];
        [_workScopeLabel sizeToFit];
        _workScopeLabel.textColor = kMainLightGray;
        _workScopeLabel.font = SystemFont(13);
    }
    return _workScopeLabel;
}

// 班次
- (UILabel *)classLabel1 {
    if (!_classLabel1) {
        _classLabel1 = [[UILabel alloc] init];
        [_classLabel1 sizeToFit];
        _classLabel1.textColor = kMainLightGray;
        _classLabel1.font = SystemFont(13);
    }
    return _classLabel1;
}
- (UILabel *)classLabel2 {
    if (!_classLabel2) {
        _classLabel2 = [[UILabel alloc] init];
        _classLabel2.textColor = kMainLightGray;
        [_classLabel2 sizeToFit];
        _classLabel2.font = SystemFont(13);
    }
    return _classLabel2;
}
- (UILabel *)classLabel3 {
    if (!_classLabel3) {
        _classLabel3 = [[UILabel alloc] init];
        _classLabel3.textColor = kMainLightGray;
        [_classLabel3 sizeToFit];
        _classLabel3.font = SystemFont(13);
    }
    return _classLabel3;
}

// 考勤日期
- (UILabel *)workDateLabel {
    if (!_workDateLabel) {
        _workDateLabel = [[UILabel alloc] init];
        [_workDateLabel sizeToFit];
        _workDateLabel.textColor = kMainLightGray;
        _workDateLabel.font = SystemFont(13);
    }
    return _workDateLabel;
}

// 地点
- (UILabel *)workLocationLabel {
    if (!_workLocationLabel) {
        _workLocationLabel = [[UILabel alloc] init];
        [_workLocationLabel sizeToFit];
        _workLocationLabel.textColor = kMainLightGray;
        _workLocationLabel.font = SystemFont(13);
    }
    return _workLocationLabel;
}

// wifi名称
- (UILabel *)workWifiLabel {
    if (!_workWifiLabel) {
        _workWifiLabel = [[UILabel alloc] init];
        [_workWifiLabel sizeToFit];
        _workWifiLabel.textColor = kMainLightGray;
        _workWifiLabel.font = SystemFont(13);
    }
    return _workWifiLabel;
}

// 左滑视图
- (UIView *)swipeView {
    if (!_swipeView) {
        _swipeView = [[UIView alloc] init];
        _swipeView.backgroundColor = kWhiteColor;
        _swipeView.layer.cornerRadius = 5;
    }
    return _swipeView;
}

- (UILabel *)swipeTitleLabel {
    if (!_swipeTitleLabel) {
        _swipeTitleLabel = [[UILabel alloc] init];
        _swipeTitleLabel.textAlignment = NSTextAlignmentCenter;
        _swipeTitleLabel.textColor = kBlackColor;
        _swipeTitleLabel.font = SystemFont(16);
        _swipeTitleLabel.text = @"删除";
    }
    return _swipeTitleLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
