//
//  MPMTableHeaderView.m
//  MPMAtendence
//  通用的tableView的header或者footer
//  Created by shengangneng on 2018/5/15.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMTableHeaderView.h"

@implementation MPMTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kTableViewBGColor;
        [self addSubview:self.headerTextLabel];
        [self.headerTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.mas_leading).offset(15);
            make.top.bottom.trailing.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - Public Method
/** 重设headerTextLabel的leading offset */
- (void)resetTextLabelLeadingOffser:(NSInteger)offset {
    [self.headerTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.mas_leading).offset(offset);
        make.top.bottom.trailing.equalTo(self);
    }];
}

#pragma mark - Lazy Init
- (UILabel *)headerTextLabel {
    if (!_headerTextLabel) {
        _headerTextLabel = [[UILabel alloc] init];
        _headerTextLabel.textColor = kMainLightGray;
        _headerTextLabel.font = SystemFont(15);
        _headerTextLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _headerTextLabel;
}

@end
