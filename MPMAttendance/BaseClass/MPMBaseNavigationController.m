//
//  MPMBaseNavigationController.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseNavigationController.h"
#import "MPMBaseNavigationBar.h"

@interface MPMBaseNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation MPMBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
}

// 左滑返回手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1) {
        return NO;
    }
    return YES;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithNavigationBarClass:[MPMBaseNavigationBar class] toolbarClass:nil];
    if (self) {
        self.viewControllers = @[rootViewController];
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
