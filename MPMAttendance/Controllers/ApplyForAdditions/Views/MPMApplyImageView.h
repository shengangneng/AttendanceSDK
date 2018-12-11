//
//  MPMApplyImageView.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/5/19.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPMApplyImageView;
typedef void(^FoldBlock)(BOOL fold);

@protocol MPMApplyImageDelegate <NSObject>

@optional
/** 选中了快捷方式的时候会回调 */
- (void)applyImageView:(MPMApplyImageView *)applyView didSelectFastIndex:(NSInteger)index;

@end

@interface MPMApplyImageView : UIImageView

/**
 * @param title  标题
 * @param image  图片
 * @param labels 快捷按钮
 */
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image labels:(NSArray *)labels;

@property (nonatomic, weak) id<MPMApplyImageDelegate> delegate;
@property (nonatomic, copy) FoldBlock foldBlock;

@end
