//
//  MPMSiderDrawerCollectionViewButtonCell.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/26.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSiderDrawerCollectionViewButtonCell.h"
#import "MPMButton.h"
#import "MPMAttendanceHeader.h"

@implementation MPMSiderDrawerCollectionViewButtonCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupAttributes];
        [self setupSubViews];
    }
    return self;
}

- (void)setupAttributes {
    [self.collectionCellButton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubViews {
    [self addSubview:self.collectionCellButton];
}

#pragma mark - Target Action
- (void)click:(UIButton *)sender {
    
}

#pragma mark - Lazy Init
- (UIButton *)collectionCellButton {
    if (!_collectionCellButton) {
        _collectionCellButton = [MPMButton titleButtonWithTitle:@"" nTitleColor:kMainTextFontColor hTitleColor:kWhiteColor bgColor:kTableViewBGColor];
        _collectionCellButton.layer.cornerRadius = 5;
        _collectionCellButton.userInteractionEnabled = NO;
        _collectionCellButton.titleLabel.font = SystemFont(14);
        [_collectionCellButton setTitleColor:kWhiteColor forState:UIControlStateSelected];
        [_collectionCellButton setBackgroundImage:ImageName(@"approval_but_determine") forState:UIControlStateSelected];
        [_collectionCellButton setTitleColor:kWhiteColor forState:UIControlStateHighlighted];
        _collectionCellButton.frame = CGRectMake(6, 6, 108.5, 31);
    }
    return _collectionCellButton;
}

@end
