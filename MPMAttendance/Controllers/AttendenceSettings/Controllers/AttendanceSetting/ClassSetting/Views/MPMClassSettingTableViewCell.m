//
//  MPMClassSettingTableViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/28.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMClassSettingTableViewCell.h"

@implementation MPMClassSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.segmentView addTarget:self action:@selector(segChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.segmentView];
        [self.segmentView mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.trailing.equalTo(self.mpm_trailing).offset(-15);
            make.width.equalTo(@(kSegmentItemWidth * kClassTypes.count));
            make.height.equalTo(@30);
            make.centerY.equalTo(self.mpm_centerY);
        }];
    }
    return self;
}

- (void)segChange:(UISegmentedControl *)sender {
    ClassType type = sender.selectedSegmentIndex;
    if (self.segChangeBlock) {
        self.segChangeBlock(type);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Lazy Init
- (UISegmentedControl *)segmentView {
    if (!_segmentView) {
        _segmentView = [[UISegmentedControl alloc] initWithItems:kClassTypes];
        _segmentView.tintColor = kMainBlueColor;
        _segmentView.layer.masksToBounds = YES;
        _segmentView.layer.cornerRadius = 5;
        _segmentView.layer.borderWidth = 1;
        _segmentView.layer.borderColor = kMainBlueColor.CGColor;
    }
    return _segmentView;
}

@end
