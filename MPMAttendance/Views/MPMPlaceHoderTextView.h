//
//  MPMPlaceHoderTextView.h
//  MPMAtendence
//
//  Created by shengangneng on 2019/1/8.
//  Copyright © 2019年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPMTempPlaceHolderLabel;

NS_ASSUME_NONNULL_BEGIN

@interface MPMPlaceHoderTextView : UITextView

- (instancetype)initWithPlaceHolder:(NSString *)placeHoder;

@property (nonatomic, strong) MPMTempPlaceHolderLabel *placeHolder;

@end

@interface MPMTempPlaceHolderLabel : UILabel

@end

NS_ASSUME_NONNULL_END
