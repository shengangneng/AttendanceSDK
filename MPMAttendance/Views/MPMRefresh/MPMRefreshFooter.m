//
//  MPMRefreshFooter.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/10/7.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMRefreshFooter.h"
#import "MPMButton.h"
#import "MPMAttendanceHeader.h"

#define kLabelWidth 150

@interface MPMRefreshFooter ()

@property (nonatomic, strong) UILabel *refreshLabel;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, assign, getter = isRefreshing) BOOL refreshing;

@end

@implementation MPMRefreshFooter

- (instancetype)initWithsuperScrollView:(UIScrollView *)scrollView {
    self = [super init];
    if (self) {
        [self addSubview:self.refreshLabel];
        [self addSubview:self.indicatorView];
        self.refreshLabel.frame = CGRectMake((kScreenWidth - kLabelWidth)/2, 0, kLabelWidth, kRefreshFooterHeight);
        self.indicatorView.frame = CGRectMake(CGRectGetMinX(self.refreshLabel.frame) - 38, 0, kRefreshFooterHeight, kRefreshFooterHeight);
        self.backgroundColor = kTableViewBGColor;
        self.superScrollView = scrollView;
        self.superContentInsets = self.superScrollView.contentInset;
        [scrollView addSubview:self];
    }
    return self;
}

- (void)beginRefreshFooter {
    if (!self.isRefreshing) {
        self.refreshing = YES;
        [self.indicatorView startAnimating];
        self.refreshLabel.text = @"正在刷新";
        UIEdgeInsets content = self.superScrollView.contentInset;
        content.bottom = content.top + content.bottom + kRefreshFooterHeight;
        self.superScrollView.contentInset = content;
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshFooterDidBeginRefresh)]) {
            [self.delegate refreshFooterDidBeginRefresh];
        }
    }
}

- (void)endRefreshFooter {
    self.refreshing = NO;
    [self.indicatorView stopAnimating];
    self.refreshLabel.text = @"上拉加载更多";
    if (self.delegate && [self.delegate respondsToSelector:@selector(refreshFooterDidEndRefresh)]) {
        [self.delegate refreshFooterDidEndRefresh];
    }
}

#pragma mark - Lazy Init

- (UILabel *)refreshLabel {
    if (!_refreshLabel) {
        _refreshLabel = [[UILabel alloc] init];
        _refreshLabel.text = @"上拉加载更多";
        _refreshLabel.textColor = kBlackColor;
        _refreshLabel.textAlignment = NSTextAlignmentCenter;
        _refreshLabel.font = SystemFont(17);
    }
    return _refreshLabel;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _indicatorView;
}

@end
