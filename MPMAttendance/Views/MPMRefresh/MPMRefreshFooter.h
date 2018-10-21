//
//  MPMRefreshFooter.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/10/7.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kRefreshFooterHeight 30

@protocol MPMRefreshFooterDelegate <NSObject>

- (void)refreshFooterDidBeginRefresh;
- (void)refreshFooterDidEndRefresh;

@end

@interface MPMRefreshFooter : UIView

/** 记录父类 */
@property (nonatomic, weak) UIScrollView *superScrollView;
@property (nonatomic, assign) UIEdgeInsets superContentInsets;
@property (nonatomic, weak) id<MPMRefreshFooterDelegate> delegate;
- (instancetype)initWithsuperScrollView:(UIScrollView *)scrollView;
- (void)beginRefreshFooter;
- (void)endRefreshFooter;

@end

NS_ASSUME_NONNULL_END
