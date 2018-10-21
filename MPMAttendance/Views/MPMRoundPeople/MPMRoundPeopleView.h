//
//  MPMRoundPeopleView.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/10/12.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRoundPeopleViewDefaultWidth 30

NS_ASSUME_NONNULL_BEGIN

@interface MPMRoundPeopleView : UIView

/** 初始化边长 */
- (instancetype)initWithWidth:(NSInteger)width;
@property (nonatomic, strong) UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
