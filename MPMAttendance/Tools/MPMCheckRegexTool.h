//
//  MPMCheckRegexTool.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/23.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPMCheckRegexTool : NSObject

/** check是否不为空字符串 */
+ (BOOL)checkIsNotNilString:(NSString *)str;

/** check手机号格式-简单验证 */
+ (BOOL)checkIsMobileNumber:(NSString*)mobileNumber;

/** check身份证号是否符合标准 */
+ (BOOL)checkIDCardNumber:(NSString *)cardNumber;

/** check身份证号生日是否超出范围 */
+ (BOOL)checkIDCardBirthdayWithCardNumber:(NSString *)cardNumber;

/** check输入数字：限制只能数字和小数点，必须以数字开头，限制数字位数和小数点后位数 */
+ (BOOL)checkString:(NSString *)str onlyHasDigitAndLength:(NSInteger)length decimalLength:(NSInteger)dLength;


@end
