//
//  NSObject+MPMExtention.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/14.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "NSObject+MPMExtention.h"
#import <objc/runtime.h>

@implementation NSObject (MPMExtention)

- (instancetype)convertModelWithDictionary:(NSDictionary *)dic {
    if (!self) {
        return nil;
    }
    unsigned int count;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    if (count == 0) return nil;
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        // 获取属性名（属性名会带有_  需要截取一下）
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *key = [name substringFromIndex:1];
        NSString *tureKey = key;
        if ([key containsString:@"mpm_"]) {
            tureKey = [key substringFromIndex:4];
        }
        id value = dic[tureKey];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            // 如果字典里面还有字典,还需要在Model里面有其他的Model作为属性来接收这个字典的对象。
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            // 生成的是这种@"@\"User\"" 类型 -》 @"User" 在OC字符串中 \" -> "，\是转义的意思，不占用字符
            // 裁剪类型字符串成User
            NSRange range = [type rangeOfString:@"\""];
            type = [type substringFromIndex:range.location + range.length];
            range = [type rangeOfString:@"\""];
            // 裁剪到哪个角标，不包括当前角标
            type = [type substringToIndex:range.location];
            // 根据字符串类名生成类对象
            Class modelClass = NSClassFromString(type);
            if (modelClass) {
                // 把Model里面的Model再用value这个dic进行转换
                value = [modelClass convertModelWithDictionary:value];
            }
        }
        
        // 如果是数组
//        if ([value isKindOfClass:[NSArray class]]) {
//            // 判断对应类有没有实现字典数组转模型数组的协议
//            if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
//
//                // 转换成id类型，就能调用任何对象的方法
//                id idSelf = self;
//
//                // 获取数组中字典对应的模型
//                NSString *type = [idSelf arrayContainModelClass][key];
//
//                // 生成模型
//                Class classModel = NSClassFromString(type);
//                NSMutableArray *arrM = [NSMutableArray array];
//                // 遍历字典数组，生成模型数组
//                for (NSDictionary *dict in value) {
//                    // 字典转模型
//                    id model = [classModel initModelWithDictionary:dict];
//                    [arrM addObject:model];
//                }
//
//                // 把模型数组赋值给value
//                value = arrM;
//
//            }
//        }
        
        if (value) {
            // 处理接口返回的Null
            id realValue;
            if ([value isKindOfClass:[NSNull class]]) {
                realValue = @"";
            } else if ([value isKindOfClass:[NSNumber class]]) {
                realValue = [NSString stringWithFormat:@"%@",value];
            } else {
                realValue = value;
            }
            [self setValue:realValue forKey:key];
        }
        
    }
    free(ivarList);
    return self;
}


@end
