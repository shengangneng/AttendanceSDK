//
//  MPMCommomTool.m
//  MPMAtendence
//
//  Created by shengangneng on 2019/1/22.
//  Copyright © 2019年 gangneng shen. All rights reserved.
//

#import "MPMCommomTool.h"
#import <UIKit/UIKit.h>

@implementation MPMCommomTool

/** 判断输入框是否含有emoji */
+ (BOOL)textViewOrTextFieldHasEmoji:(id)textViewOrTextField {
    if ([textViewOrTextField isKindOfClass:[UITextView class]]) {
        if ([((UITextView *)textViewOrTextField).textInputMode.primaryLanguage isEqualToString:@"emoji"] || !((UITextView *)textViewOrTextField).textInputMode.primaryLanguage) {
            return YES;
        }
        return NO;
    } else if ([textViewOrTextField isKindOfClass:[UITextField class]]) {
        if ([((UITextField *)textViewOrTextField).textInputMode.primaryLanguage isEqualToString:@"emoji"] || !((UITextField *)textViewOrTextField).textInputMode.primaryLanguage) {
            return YES;
        }
        return NO;
    }
    return NO;
}

@end
