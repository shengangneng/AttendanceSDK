//
//  MPMBaseNavigationBar.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseNavigationBar.h"

@implementation MPMBaseNavigationBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableDictionary * textDic = [NSMutableDictionary dictionaryWithCapacity:4];
        [textDic setObject:BoldSystemFont(20) forKey:NSFontAttributeName];
        [textDic setObject:kWhiteColor forKey:NSForegroundColorAttributeName];
        self.barStyle = UIBarStyleBlack;
        self.titleTextAttributes = textDic;
        self.translucent = NO;
        [self setBackgroundImage:ImageName(@"statistics_nav") forBarMetrics:UIBarMetricsDefault];
        [self setShadowImage:[[UIImage alloc] init]];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // iOS8~10
    Class backgroundClass = NSClassFromString(@"_UINavigationBarBackground");
    Class statusBarBackgroundClass = NSClassFromString(@"_UIBarBackgroundTopCurtainView");
    // iOS10
    Class barBackground = NSClassFromString(@"_UIBarBackground");
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:backgroundClass]) {
            for (UIView * v in view.subviews) {
                if ([v isKindOfClass:statusBarBackgroundClass]) {
                    v.backgroundColor = kMainBlueColor;
                }
            }
        } else if ([view isKindOfClass:barBackground]) {
            view.backgroundColor = kMainBlueColor;
            if (view.subviews.count > 1) {
                view.subviews[1].hidden = YES;
            }
        }
    }
}

@end
