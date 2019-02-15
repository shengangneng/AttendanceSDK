//
//  MPMCycleScrollViewCell.m
//  MPMAtendence
//
//  Created by shengangneng on 2019/2/12.
//  Copyright © 2019年 gangneng shen. All rights reserved.
//

#import "MPMCycleScrollViewCell.h"
#import "MPMApplyCollectionViewCell.h"
#import "MPMAttendanceHeader.h"

typedef void(^OperationBlock)(BOOL fold);

static NSString *const kCollectionViewIdentifier = @"CollectionView";

@interface MPMCycleScrollViewCell () <UICollectionViewDelegate, UICollectionViewDataSource>

/** 设置快捷按钮的标题 */
@property (nonatomic, copy) NSArray<NSString *> *labels;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) BOOL fold;
@property (nonatomic, copy) OperationBlock operation;

@end

@implementation MPMCycleScrollViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.rightIcon];
        [self addSubview:self.detailLabel];
        [self addSubview:self.centerIcon];
        [self addSubview:self.collectionView];
        [self addSubview:self.bottomButton];
        
        [self.bgView mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.nameLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading).offset(50);
            make.top.equalTo(self.mpm_top).offset(20);
        }];
        [self.rightIcon mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.width.equalTo(@13);
            make.height.equalTo(@13);
            make.centerY.equalTo(self.nameLabel.mpm_centerY);
            make.trailing.equalTo(self.mpm_trailing).offset(-22);
        }];
        [self.detailLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.mpm_leading).offset(15);
            make.trailing.equalTo(self.mpm_trailing).offset(-15);
            make.top.equalTo(self.nameLabel.mpm_bottom).offset(17);
        }];
        [self.centerIcon mpm_makeConstraints:^(MPMConstraintMaker *make) {
            if (kScreenWidth <= 320) {
                make.width.equalTo(@190);
                make.height.equalTo(@(141.5));
            } else {
                make.width.equalTo(@235);
                make.height.equalTo(@175);
            }
            make.centerX.equalTo(self.mpm_centerX);
            make.centerY.equalTo(self.mpm_centerY).offset(16);
        }];
        [self.collectionView mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.mpm_bottom).offset(-5);
            make.height.equalTo(@40);
        }];
        [self.bottomButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.height.equalTo(@20);
        }];
        self.fold = NO;
        [self.bottomButton addTarget:self action:@selector(fold:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

#pragma mark - Target Action
- (void)fold:(UIButton *)sender {
    if (self.fold) {
        self.fold = NO;
        [UIView animateWithDuration:0.5 animations:^{
            [self.bottomButton setImage:ImageName(@"apply_downwhite") forState:UIControlStateNormal];
            [self.collectionView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                make.leading.trailing.equalTo(self);
                make.bottom.equalTo(self.mpm_bottom).offset(-8);
                make.height.equalTo(@40);
            }];
        }];
        [self.collectionView reloadData];
    } else {
        self.fold = YES;
        [UIView animateWithDuration:0.5 animations:^{
            [self.bottomButton setImage:ImageName(@"apply_upwhite") forState:UIControlStateNormal];
            [self.collectionView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
                make.leading.trailing.equalTo(self);
                make.bottom.equalTo(self.mpm_bottom).offset(-8);
                make.height.equalTo(@80);
            }];
        }];
        [self.collectionView reloadData];
    }
    if (self.operation) {
        self.operation(self.fold);
    }
}

- (void)setLabels:(NSArray<NSString *> *)labels borderColor:(UIColor *)color fold:(BOOL)fold operationBlock:(nonnull void (^)(BOOL))operation {
    _labels = labels;
    _borderColor = color;
    _fold = fold;
    _operation = operation;
    NSInteger height = 40;
    if (fold) {
        height = 80;
        [self.bottomButton setImage:ImageName(@"apply_upwhite") forState:UIControlStateNormal];
    } else {
        height = 40;
        [self.bottomButton setImage:ImageName(@"apply_downwhite") forState:UIControlStateNormal];
    }
    [self.collectionView mpm_remakeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(self.mpm_bottom).offset(-8);
        make.height.equalTo(@(height));
    }];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate && UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.labels.count <= 3) {
        self.bottomButton.hidden = YES;
        return self.labels.count;
    } else {
        self.bottomButton.hidden = NO;
        if (self.fold) {
            return self.labels.count;
        } else {
            return 3;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MPMApplyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewIdentifier forIndexPath:indexPath];
    NSString *title = self.labels[indexPath.row];
    cell.borderColor = self.borderColor;
    cell.quickLabel.text = title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 跳到例外申请详情
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewCell:didSelectFastIndex:)]) {
        [self.delegate scrollViewCell:self didSelectFastIndex:indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((250)/3, 40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - Lazy Init
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.layer.cornerRadius = 10;
        _bgView.layer.shadowOffset = CGSizeMake(1, 3);
        _bgView.layer.shadowOpacity = 0.5;
        _bgView.layer.shadowRadius = 5;
    }
    return _bgView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = kWhiteColor;
        _nameLabel.font = BoldSystemFont(30);
        _nameLabel.text = @"请假";
        [_nameLabel sizeToFit];
    }
    return _nameLabel;
}

- (UIImageView *)rightIcon {
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] initWithImage:ImageName(@"apply_rightwhite")];
    }
    return _rightIcon;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.textColor = kWhiteColor;
        _detailLabel.font = SystemFont(13);
        _detailLabel.numberOfLines = 0;
        [_detailLabel sizeToFit];
    }
    return _detailLabel;
}

- (UIImageView *)centerIcon {
    if (!_centerIcon) {
        _centerIcon = [[UIImageView alloc] init];
    }
    return _centerIcon;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.headerReferenceSize = CGSizeMake(0, 0);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = kClearColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView sizeToFit];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[MPMApplyCollectionViewCell class] forCellWithReuseIdentifier:kCollectionViewIdentifier];
    }
    return _collectionView;
}

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomButton setImage:ImageName(@"apply_downwhite") forState:UIControlStateNormal];
    }
    return _bottomButton;
}

@end
