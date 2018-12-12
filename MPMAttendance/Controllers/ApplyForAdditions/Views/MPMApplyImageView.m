//
//  MPMApplyImageView.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMApplyImageView.h"
#import "MPMAttendanceHeader.h"
#import "MPMButton.h"
#import "MPMDealingBorderButton.h"
#import "MPMApplyCollectionViewCell.h"

static NSString *const kCollectionViewIdentifier = @"CollectionView";

@interface MPMApplyImageView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *pushButton;         /** 上半部分用来响应的按钮 */
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *foldButton;
// data
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, copy) NSArray *labels;
@property (nonatomic, assign) BOOL needFold;

@end

@implementation MPMApplyImageView

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image labels:(NSArray *)labels {
    self = [super init];
    if (self) {
        self.iconImage = image;
        self.labels = labels;
        self.needFold = YES;
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.rightButton];
        [self addSubview:self.pushButton];
        [self addSubview:self.lineView];
        [self addSubview:self.collectionView];
        [self addSubview:self.foldButton];
        [self.foldButton addTarget:self action:@selector(fold:) forControlEvents:UIControlEventTouchUpInside];
        [self.pushButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        
        self.titleLabel.text =  title;
        [self.titleLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.equalTo(self.iconImageView.mpm_trailing).offset(10);
            make.centerY.equalTo(self.iconImageView.mpm_centerY);
        }];
        [self.rightButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.width.height.equalTo(@15);
            make.trailing.equalTo(self.mpm_trailing).offset(-10);
            make.centerY.equalTo(self.iconImageView.mpm_centerY);
        }];
        [self.pushButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
            make.leading.trailing.top.equalTo(self);
            make.centerY.equalTo(self.iconImageView.mpm_centerY);
        }];
        if (self.labels.count == 0) {
            [self.iconImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.width.height.equalTo(@25);
                make.leading.equalTo(self.mpm_leading).offset(10);
                make.centerY.equalTo(self.mpm_centerY);
            }];
        } else {
            [self.iconImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.width.height.equalTo(@25);
                make.leading.equalTo(self.mpm_leading).offset(10);
                make.top.equalTo(self.mpm_top).offset(16);
            }];
            [self.lineView mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.leading.equalTo(self.mpm_leading).offset(10);
                make.trailing.equalTo(self.mpm_trailing).offset(-10);
                make.height.equalTo(@0.5);
                make.top.equalTo(self.iconImageView.mpm_bottom).offset(16);
            }];
            [self.collectionView mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.leading.trailing.bottom.equalTo(self);
                make.top.equalTo(self.lineView.mpm_bottom).offset(15);
            }];
            if (self.labels.count > 4) {
                [self.foldButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
                    make.leading.trailing.equalTo(self);
                    make.height.equalTo(@27);
                    make.bottom.equalTo(self.mpm_bottom);
                }];
            }
        }
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (int i = 0; i < self.layer.sublayers.count; i++) {
        CALayer *layer = self.layer.sublayers[i];
        if ([layer isKindOfClass:[CAGradientLayer class]]) {
            layer.frame = self.bounds;
        }
    }
}

#pragma mark - Target Action
- (void)fold:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.needFold = !sender.selected;
    [self.collectionView reloadData];
    if (self.foldBlock) {
        self.foldBlock(self.needFold);
    }
}

- (void)push:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(applyImageView:didSelectFastIndex:)]) {
        [self.delegate applyImageView:self didSelectFastIndex:-1];
    }
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.needFold) {
        return self.labels.count > 4 ? 4 : self.labels.count;
    } else {
        return self.labels.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MPMApplyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewIdentifier forIndexPath:indexPath];
    NSString *title = self.labels[indexPath.row];
    cell.quickLabel.text = title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 跳到例外申请详情
    if (self.delegate && [self.delegate respondsToSelector:@selector(applyImageView:didSelectFastIndex:)]) {
        [self.delegate applyImageView:self didSelectFastIndex:indexPath.row];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenWidth/4 - 5, 45);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - Lazy Init

- (UIButton *)pushButton {
    if (!_pushButton) {
        _pushButton = [[UIButton alloc] init];
    }
    return _pushButton;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithImage:self.iconImage];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kWhiteColor;
        _titleLabel.font = BoldSystemFont(18);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kWhiteColor;
    }
    return _lineView;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [MPMButton imageButtonWithImage:ImageName(@"apply_whiteright") hImage:ImageName(@"apply_whiteright")];
    }
    return _rightButton;
}

- (UIButton *)foldButton {
    if (!_foldButton) {
        _foldButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_foldButton setImage:ImageName(@"apply_whiterup")  forState:UIControlStateNormal];
        [_foldButton setImage:ImageName(@"apply_whiterup")  forState:UIControlStateHighlighted];
        [_foldButton setImage:ImageName(@"apply_whiterdown")  forState:UIControlStateSelected];
        _foldButton.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _foldButton;
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

@end
