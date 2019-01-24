//
//  MPMCommomTool.h
//  MPMAtendence
//
//  Created by shengangneng on 2019/1/22.
//  Copyright © 2019年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPMCommomTool : NSObject

/** 判断输入框是否含有emoji */
+ (BOOL)textViewOrTextFieldHasEmoji:(id)textViewOrTextField;

@end

NS_ASSUME_NONNULL_END
