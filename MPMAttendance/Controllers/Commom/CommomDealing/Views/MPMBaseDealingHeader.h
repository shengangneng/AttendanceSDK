//
//  MPMBaseDealingHeader.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/9/6.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SeeDetailBlock)(void);
typedef void(^DeleteBlock)(void);

@interface MPMBaseDealingHeader : UIView

@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, strong) UIButton *seeDetailButton;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, copy) SeeDetailBlock seeDetailBlock;
@property (nonatomic, copy) DeleteBlock deleteBlock;

@end
