//
//  UIView+MPMAdditions.m
//  MPMMasonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "View+MPMAdditions.h"
#import <objc/runtime.h>

@implementation MPM_VIEW (MPMAdditions)

- (NSArray *)mpm_makeConstraints:(void(^)(MPMConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    MPMConstraintMaker *constraintMaker = [[MPMConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)mpm_updateConstraints:(void(^)(MPMConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    MPMConstraintMaker *constraintMaker = [[MPMConstraintMaker alloc] initWithView:self];
    constraintMaker.updateExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)mpm_remakeConstraints:(void(^)(MPMConstraintMaker *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    MPMConstraintMaker *constraintMaker = [[MPMConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

#pragma mark - NSLayoutAttribute properties

- (MPMViewAttribute *)mpm_left {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (MPMViewAttribute *)mpm_top {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (MPMViewAttribute *)mpm_right {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (MPMViewAttribute *)mpm_bottom {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (MPMViewAttribute *)mpm_leading {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeading];
}

- (MPMViewAttribute *)mpm_trailing {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailing];
}

- (MPMViewAttribute *)mpm_width {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (MPMViewAttribute *)mpm_height {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

- (MPMViewAttribute *)mpm_centerX {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (MPMViewAttribute *)mpm_centerY {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (MPMViewAttribute *)mpm_baseline {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBaseline];
}

- (MPMViewAttribute *(^)(NSLayoutAttribute))mpm_attribute
{
    return ^(NSLayoutAttribute attr) {
        return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:attr];
    };
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (MPMViewAttribute *)mpm_firstBaseline {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (MPMViewAttribute *)mpm_lastBaseline {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

- (MPMViewAttribute *)mpm_leftMargin {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeftMargin];
}

- (MPMViewAttribute *)mpm_rightMargin {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRightMargin];
}

- (MPMViewAttribute *)mpm_topMargin {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTopMargin];
}

- (MPMViewAttribute *)mpm_bottomMargin {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottomMargin];
}

- (MPMViewAttribute *)mpm_leadingMargin {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (MPMViewAttribute *)mpm_trailingMargin {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (MPMViewAttribute *)mpm_centerXWithinMargins {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (MPMViewAttribute *)mpm_centerYWithinMargins {
    return [[MPMViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

- (MPMViewAttribute *)mpm_safeAreaLayoutGuide {
    return [[MPMViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (MPMViewAttribute *)mpm_safeAreaLayoutGuideTop {
    return [[MPMViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (MPMViewAttribute *)mpm_safeAreaLayoutGuideBottom {
    return [[MPMViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (MPMViewAttribute *)mpm_safeAreaLayoutGuideLeft {
    return [[MPMViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeft];
}
- (MPMViewAttribute *)mpm_safeAreaLayoutGuideRight {
    return [[MPMViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeRight];
}

#endif

#pragma mark - associated properties

- (id)mpm_key {
    return objc_getAssociatedObject(self, @selector(mpm_key));
}

- (void)setMpm_key:(id)key {
    objc_setAssociatedObject(self, @selector(mpm_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - heirachy

- (instancetype)mpm_closestCommonSuperview:(MPM_VIEW *)view {
    MPM_VIEW *closestCommonSuperview = nil;

    MPM_VIEW *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        MPM_VIEW *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

@end
