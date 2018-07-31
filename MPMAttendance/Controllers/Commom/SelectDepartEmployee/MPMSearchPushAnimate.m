//
//  MPMSearchPushAnimate.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/7/10.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSearchPushAnimate.h"
#import "MPMSelectDepartmentViewController.h"
#import "MPMSearchDepartViewController.h"

@implementation MPMSearchPushAnimate

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    MPMSelectDepartmentViewController *fromViewController = (MPMSelectDepartmentViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MPMSearchDepartViewController *toViewController = (MPMSearchDepartViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    // 创建一个复合视图的快照并返回一个UIView对象来表示调用视图的整体外观。NO会立即生成快照
    UIView *imageSnapshot1 = [fromViewController.headerView snapshotViewAfterScreenUpdates:NO];
    UIView *imageSnapshot2 = [fromViewController.headerSearchBar snapshotViewAfterScreenUpdates:NO];
    imageSnapshot1.frame = [containerView convertRect:fromViewController.headerView.frame fromView:fromViewController.headerView.superview];
    imageSnapshot2.frame = [containerView convertRect:fromViewController.headerSearchBar.frame fromView:fromViewController.headerSearchBar.superview];
    fromViewController.headerView.hidden = YES;
    fromViewController.headerSearchBar.hidden = YES;
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    toViewController.headerView.hidden = YES;
    toViewController.headerSearchBar.hidden = YES;
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:imageSnapshot1];
    [containerView addSubview:imageSnapshot2];
    
    [UIView animateWithDuration:duration animations:^{
        toViewController.view.alpha = 1.0;
        CGRect frame1 = CGRectMake(0, 0, kScreenWidth, 52 + kStatusBarHeight);
        imageSnapshot1.frame = frame1;
        CGRect frame2 = CGRectMake(0, kStatusBarHeight, kScreenWidth, 52);
        imageSnapshot2.frame = frame2;
    } completion:^(BOOL finished) {
        toViewController.headerView.hidden = NO;
        toViewController.headerSearchBar.hidden = NO;
        fromViewController.headerView.hidden = NO;
        fromViewController.headerSearchBar.hidden = NO;
        [imageSnapshot1 removeFromSuperview];
        [imageSnapshot2 removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

@end
