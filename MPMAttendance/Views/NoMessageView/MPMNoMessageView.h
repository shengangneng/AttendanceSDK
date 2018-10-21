//
//  MPMNoMessageView.h
//  MPMAtendence
//  无信息视图
//  Created by shengangneng on 2018/10/11.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPreferNoMessaegViewWidthHeight 300

NS_ASSUME_NONNULL_BEGIN

@interface MPMNoMessageView : UIView

/**
 * 通过传入图片名和无数据时候的文字创建无数据视图
 * @param imageName 无数据图片，不能为空
 * @param text 无数据时显示的文字，如果为空，则不创建label
 */
- (instancetype)initWithNoMessageViewImage:(nonnull NSString *)imageName noMessageLabelText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
