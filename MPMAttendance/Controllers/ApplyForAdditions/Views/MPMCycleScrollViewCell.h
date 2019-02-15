//
//  MPMCycleScrollViewCell.h
//  MPMAtendence
//
//  Created by shengangneng on 2019/2/12.
//  Copyright © 2019年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPMCycleScrollViewCell;

NS_ASSUME_NONNULL_BEGIN
@protocol MPMCycleScrollViewCellDelegate <NSObject>

@optional
/** 选中了快捷方式的时候会回调 */
- (void)scrollViewCell:(MPMCycleScrollViewCell *)scrollViewCell didSelectFastIndex:(NSInteger)index;

@end

@interface MPMCycleScrollViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *rightIcon;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *centerIcon;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *bottomButton;
@property (nonatomic, assign) CGFloat cornerRadius;

- (void)setLabels:(NSArray<NSString *> *)labels borderColor:(UIColor *)color fold:(BOOL)fold operationBlock:(void(^)(BOOL))operation;

@property (nonatomic, weak) id<MPMCycleScrollViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
