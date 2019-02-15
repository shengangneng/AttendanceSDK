//
//  MPMCycleScrollView.h
//  MPMAtendence
//
//  Created by shengangneng on 2019/2/12.
//  Copyright © 2019年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class MPMCycleScrollView;

@protocol MPMCycleScrollViewDelegate <NSObject>

/** 点击快捷申请和图片：图片index传-1 */
- (void)cycleScrollView:(MPMCycleScrollView *)cycleScrollView didSelectFastIndex:(NSInteger)index;
@optional
/** 当图片手动滑动或自动切换时回调，返回当前页码，用于外部自定义pageControl时，切换当前页使用 */
- (void)cycleScrollView:(MPMCycleScrollView *)cycleScrollView currentPageIndex:(NSInteger)index;

@end

@interface MPMCycleScrollView : UIView
/** 是否无限循环，默认为YES，如果设置为NO，则需要自己设置collectionView的pageEnabled属性 */
@property (nonatomic, assign, getter = isCycleLoop) BOOL cycleLoop;
/** 是否缩放，默认为NO不缩放 */
@property (nonatomic, assign) BOOL isZoom;

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemSpace;
@property (nonatomic, assign) CGFloat cornerRadius;/** 图片的cornerRadius */

@property (nonatomic, assign) NSInteger currentIndex;/** 记录当前的index */

/** 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;

@property (nonatomic, weak) id<MPMCycleScrollViewDelegate> delegate;
/** 初始化方法 如果cycleLoop设置成NO，则需要调用setCollectionViewPagingEnabled方法设置pagingEnabled属性，默认pagingEnabled是NO */
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldCycleLoop:(BOOL)cycleLoop imageGroups:(NSArray<UIImage *> *)imageGroups;

/** 设置分页滑动属性（如果cycleLoop属性为yes，则设置无效）*/
- (void)setCollectionViewPagingEnabled:(BOOL)pagingEnabled;
- (void)scrollToIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
