//
//  MPMSearchPopAnimate.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/7/10.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSearchPopAnimate.h"
#import "MPMSelectDepartmentViewController.h"
#import "MPMSearchDepartViewController.h"

@implementation MPMSearchPopAnimate


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    // 获取跳转的两个控制器
    MPMSearchDepartViewController *fromViewController = (MPMSearchDepartViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    MPMSelectDepartmentViewController *toViewController = (MPMSelectDepartmentViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView *imageSnapshot1 = [fromViewController.headerView snapshotViewAfterScreenUpdates:NO];
    UIView *imageSnapshot2 = [fromViewController.headerSearchBar snapshotViewAfterScreenUpdates:NO];
    imageSnapshot1.frame = [containerView convertRect:fromViewController.headerView.frame fromView:fromViewController.headerView.superview];
    imageSnapshot2.frame = [containerView convertRect:fromViewController.headerSearchBar.frame fromView:fromViewController.headerSearchBar.superview];
    fromViewController.headerView.hidden = YES;
    fromViewController.headerSearchBar.hidden = YES;
    
    toViewController.headerView.hidden = YES;
    toViewController.headerSearchBar.hidden = YES;
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    [containerView addSubview:imageSnapshot1];
    [containerView addSubview:imageSnapshot2];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        fromViewController.view.alpha = 0.0;
        imageSnapshot1.frame = CGRectMake(0, kNavigationHeight, kScreenWidth, 52);
        imageSnapshot2.frame = CGRectMake(0, kNavigationHeight, kScreenWidth, 52);
    } completion:^(BOOL finished) {
        [imageSnapshot1 removeFromSuperview];
        [imageSnapshot2 removeFromSuperview];
        fromViewController.headerView.hidden = NO;
        fromViewController.headerSearchBar.hidden = NO;
        toViewController.headerView.hidden = NO;
        toViewController.headerSearchBar.hidden = NO;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3f;
}

@end
