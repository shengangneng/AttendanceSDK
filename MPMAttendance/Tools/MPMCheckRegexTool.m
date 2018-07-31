//
//  MPMCheckRegexTool.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/23.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMCheckRegexTool.h"

@implementation MPMCheckRegexTool

+ (BOOL)checkIsNotNilString:(NSString *)str {
    if (!str) return NO;
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (![str isEqualToString:@""]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)checkIsMobileNumber:(NSString*)mobileNumber {
    NSString *regex = @"^1[34578]\\d{9}$";
    NSPredicate *regexTestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([regexTestMobile evaluateWithObject:mobileNumber]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)checkIDCardNumber:(NSString *)cardNumber {
    cardNumber = [cardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([cardNumber length] == 18) {
        // 第18位校验
        int summary = ([cardNumber substringWithRange:NSMakeRange(0,1)].intValue + [cardNumber substringWithRange:NSMakeRange(10,1)].intValue) *7
        + ([cardNumber substringWithRange:NSMakeRange(1,1)].intValue + [cardNumber substringWithRange:NSMakeRange(11,1)].intValue) *9
        + ([cardNumber substringWithRange:NSMakeRange(2,1)].intValue + [cardNumber substringWithRange:NSMakeRange(12,1)].intValue) *10
        + ([cardNumber substringWithRange:NSMakeRange(3,1)].intValue + [cardNumber substringWithRange:NSMakeRange(13,1)].intValue) *5
        + ([cardNumber substringWithRange:NSMakeRange(4,1)].intValue + [cardNumber substringWithRange:NSMakeRange(14,1)].intValue) *8
        + ([cardNumber substringWithRange:NSMakeRange(5,1)].intValue + [cardNumber substringWithRange:NSMakeRange(15,1)].intValue) *4
        + ([cardNumber substringWithRange:NSMakeRange(6,1)].intValue + [cardNumber substringWithRange:NSMakeRange(16,1)].intValue) *2
        + [cardNumber substringWithRange:NSMakeRange(7,1)].intValue *1 + [cardNumber substringWithRange:NSMakeRange(8,1)].intValue *6
        + [cardNumber substringWithRange:NSMakeRange(9,1)].intValue *3;
        NSInteger remainder = summary % 11;
        NSString *checkBit = @"";
        NSString *checkString = @"10X98765432";
        checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
        return [checkBit isEqualToString:[[cardNumber substringWithRange:NSMakeRange(17,1)] uppercaseString]];
    }
    return NO;
}

+ (BOOL)checkIDCardBirthdayWithCardNumber:(NSString *)cardNumber {
    cardNumber = [cardNumber stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([cardNumber length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:cardNumber]) {
        return NO;
    }
    return YES;
}

/** 限制数字和小数点：必须以数字开头，限制数字位数和小数点后位数 */
+ (BOOL)checkString:(NSString *)str onlyHasDigitAndLength:(NSInteger)length decimalLength:(NSInteger)dLength {
    NSString *regex = [NSString stringWithFormat:@"^[0-9]{1,%ld}+(\\.[0-9]{0,%ld})?$", (long)length, (long)dLength];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:str] || [str isEqualToString:@""];
}

@end
