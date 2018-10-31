//
//  MPMProcessDetailDeliversView.m
//  MPMAtendence
//  信息详情抄送人
//  Created by shengangneng on 2018/9/18.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMProcessDetailDeliversView.h"
#import "MPMButton.h"
#import "MPMRoundPeopleButton.h"

#define kItemsPerPage   5
#define kItemWidth      50

@interface MPMProcessDetailDeliversView ()

@property (nonatomic, strong) UILabel *deliverLabel;
@property (nonatomic, strong) UIScrollView *deliversView;
@property (nonatomic, strong) UIView *deliversContainerView;

@end

@implementation MPMProcessDetailDeliversView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.deliverLabel];
        [self addSubview:self.deliversView];
        [self.deliversView addSubview:self.deliversContainerView];
        [self.deliverLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading).offset(23);
            make.height.equalTo(@16);
            make.width.equalTo(@87);
            make.top.equalTo(self.mpm_top).offset(5);
        }];
        [self.deliversView mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.top.equalTo(self.deliverLabel.mpm_bottom).offset(5);
        }];
        [self.deliversContainerView mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.edges.equalTo(self.deliversView);
            make.width.equalTo(@(kScreenWidth));
            make.height.equalTo(@50);
        }];
    }
    return self;
}

- (void)setDelivers:(NSArray<MPMProcessPeople *> *)delivers {
    _delivers = delivers;
    for (UIView *subView in self.deliversView.subviews) {
        if ([subView isKindOfClass:[MPMRoundPeopleButton class]]) {
            [subView removeFromSuperview];
        }
    }
    
    int bord = (kScreenWidth - kItemsPerPage * kItemWidth) / (kItemsPerPage + 1);
    [self.deliversContainerView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
        make.edges.equalTo(self.deliversView);
        make.width.equalTo(@((kItemWidth + bord) * delivers.count + bord));
        make.height.equalTo(@50);
    }];
    
    if (delivers.count > 0) {
        MPMViewAttribute *lastAttribute = self.deliversContainerView.mpm_leading;
        for (int i = 0; i < delivers.count; i++) {
            MPMProcessPeople *people = delivers[i];
            MPMRoundPeopleButton *btn = [[MPMRoundPeopleButton alloc] init];
            btn.backgroundColor = kTableViewBGColor;
            btn.roundPeople.backgroundColor = kTableViewBGColor;
            btn.roundPeople.nameLabel.text = people.userName.length > 2 ? [people.userName substringWithRange:NSMakeRange(people.userName.length - 2, 2)] : people.userName;
            btn.nameLabel.text = people.userName;
            [self.deliversContainerView addSubview:btn];
            [btn mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.width.height.equalTo(@(kItemWidth));
                make.centerY.equalTo(self.deliversContainerView.mpm_centerY);
                make.leading.equalTo(lastAttribute).offset(bord);
            }];
            lastAttribute = btn.mpm_trailing;
        }
    }
}

- (UILabel *)deliverLabel {
    if (!_deliverLabel) {
        _deliverLabel = [[UILabel alloc] init];
        _deliverLabel.textColor = kMainLightGray;
        _deliverLabel.text = @"抄送人";
        _deliverLabel.font = SystemFont(13);
        _deliverLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _deliverLabel;
}

- (UIScrollView *)deliversView {
    if (!_deliversView) {
        _deliversView = [[UIScrollView alloc] init];
    }
    return _deliversView;
}

- (UIView *)deliversContainerView {
    if (!_deliversContainerView) {
        _deliversContainerView = [[UIView alloc] init];
    }
    return _deliversContainerView;
}

@end
