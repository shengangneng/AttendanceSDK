//
//  MPMConstraintMaker.m
//  MPMMasonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MPMConstraintMaker.h"
#import "MPMViewConstraint.h"
#import "MPMCompositeConstraint.h"
#import "MPMConstraint+Private.h"
#import "MPMViewAttribute.h"
#import "View+MPMAdditions.h"

@interface MPMConstraintMaker () <MPMConstraintDelegate>

@property (nonatomic, weak) MPM_VIEW *view;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation MPMConstraintMaker

- (id)initWithView:(MPM_VIEW *)view {
    self = [super init];
    if (!self) return nil;
    
    self.view = view;
    self.constraints = NSMutableArray.new;
    
    return self;
}

- (NSArray *)install {
    if (self.removeExisting) {
        NSArray *installedConstraints = [MPMViewConstraint installedConstraintsForView:self.view];
        for (MPMConstraint *constraint in installedConstraints) {
            [constraint uninstall];
        }
    }
    NSArray *constraints = self.constraints.copy;
    for (MPMConstraint *constraint in constraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
    [self.constraints removeAllObjects];
    return constraints;
}

#pragma mark - MPMConstraintDelegate

- (void)constraint:(MPMConstraint *)constraint shouldBeReplacedWithConstraint:(MPMConstraint *)replacementConstraint {
    NSUInteger index = [self.constraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.constraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (MPMConstraint *)constraint:(MPMConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    MPMViewAttribute *viewAttribute = [[MPMViewAttribute alloc] initWithView:self.view layoutAttribute:layoutAttribute];
    MPMViewConstraint *newConstraint = [[MPMViewConstraint alloc] initWithFirstViewAttribute:viewAttribute];
    if ([constraint isKindOfClass:MPMViewConstraint.class]) {
        //replace with composite constraint
        NSArray *children = @[constraint, newConstraint];
        MPMCompositeConstraint *compositeConstraint = [[MPMCompositeConstraint alloc] initWithChildren:children];
        compositeConstraint.delegate = self;
        [self constraint:constraint shouldBeReplacedWithConstraint:compositeConstraint];
        return compositeConstraint;
    }
    if (!constraint) {
        newConstraint.delegate = self;
        [self.constraints addObject:newConstraint];
    }
    return newConstraint;
}

- (MPMConstraint *)addConstraintWithAttributes:(MPMAttribute)attrs {
    __unused MPMAttribute anyAttribute = (MPMAttributeLeft | MPMAttributeRight | MPMAttributeTop | MPMAttributeBottom | MPMAttributeLeading
                                          | MPMAttributeTrailing | MPMAttributeWidth | MPMAttributeHeight | MPMAttributeCenterX
                                          | MPMAttributeCenterY | MPMAttributeBaseline
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
                                          | MPMAttributeFirstBaseline | MPMAttributeLastBaseline
#endif
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
                                          | MPMAttributeLeftMargin | MPMAttributeRightMargin | MPMAttributeTopMargin | MPMAttributeBottomMargin
                                          | MPMAttributeLeadingMargin | MPMAttributeTrailingMargin | MPMAttributeCenterXWithinMargins
                                          | MPMAttributeCenterYWithinMargins
#endif
                                          );
    
    NSAssert((attrs & anyAttribute) != 0, @"You didn't pass any attribute to make.attributes(...)");
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    if (attrs & MPMAttributeLeft) [attributes addObject:self.view.mpm_left];
    if (attrs & MPMAttributeRight) [attributes addObject:self.view.mpm_right];
    if (attrs & MPMAttributeTop) [attributes addObject:self.view.mpm_top];
    if (attrs & MPMAttributeBottom) [attributes addObject:self.view.mpm_bottom];
    if (attrs & MPMAttributeLeading) [attributes addObject:self.view.mpm_leading];
    if (attrs & MPMAttributeTrailing) [attributes addObject:self.view.mpm_trailing];
    if (attrs & MPMAttributeWidth) [attributes addObject:self.view.mpm_width];
    if (attrs & MPMAttributeHeight) [attributes addObject:self.view.mpm_height];
    if (attrs & MPMAttributeCenterX) [attributes addObject:self.view.mpm_centerX];
    if (attrs & MPMAttributeCenterY) [attributes addObject:self.view.mpm_centerY];
    if (attrs & MPMAttributeBaseline) [attributes addObject:self.view.mpm_baseline];
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    if (attrs & MPMAttributeFirstBaseline) [attributes addObject:self.view.mpm_firstBaseline];
    if (attrs & MPMAttributeLastBaseline) [attributes addObject:self.view.mpm_lastBaseline];
    
#endif
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
    
    if (attrs & MPMAttributeLeftMargin) [attributes addObject:self.view.mpm_leftMargin];
    if (attrs & MPMAttributeRightMargin) [attributes addObject:self.view.mpm_rightMargin];
    if (attrs & MPMAttributeTopMargin) [attributes addObject:self.view.mpm_topMargin];
    if (attrs & MPMAttributeBottomMargin) [attributes addObject:self.view.mpm_bottomMargin];
    if (attrs & MPMAttributeLeadingMargin) [attributes addObject:self.view.mpm_leadingMargin];
    if (attrs & MPMAttributeTrailingMargin) [attributes addObject:self.view.mpm_trailingMargin];
    if (attrs & MPMAttributeCenterXWithinMargins) [attributes addObject:self.view.mpm_centerXWithinMargins];
    if (attrs & MPMAttributeCenterYWithinMargins) [attributes addObject:self.view.mpm_centerYWithinMargins];
    
#endif
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:attributes.count];
    
    for (MPMViewAttribute *a in attributes) {
        [children addObject:[[MPMViewConstraint alloc] initWithFirstViewAttribute:a]];
    }
    
    MPMCompositeConstraint *constraint = [[MPMCompositeConstraint alloc] initWithChildren:children];
    constraint.delegate = self;
    [self.constraints addObject:constraint];
    return constraint;
}

#pragma mark - standard Attributes

- (MPMConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return [self constraint:nil addConstraintWithLayoutAttribute:layoutAttribute];
}

- (MPMConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (MPMConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (MPMConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (MPMConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (MPMConstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (MPMConstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (MPMConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (MPMConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (MPMConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (MPMConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (MPMConstraint *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}

- (MPMConstraint *(^)(MPMAttribute))attributes {
    return ^(MPMAttribute attrs){
        return [self addConstraintWithAttributes:attrs];
    };
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (MPMConstraint *)firstBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline];
}

- (MPMConstraint *)lastBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif


#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

- (MPMConstraint *)leftMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}

- (MPMConstraint *)rightMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}

- (MPMConstraint *)topMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}

- (MPMConstraint *)bottomMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}

- (MPMConstraint *)leadingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (MPMConstraint *)trailingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (MPMConstraint *)centerXWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (MPMConstraint *)centerYWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif


#pragma mark - composite Attributes

- (MPMConstraint *)edges {
    return [self addConstraintWithAttributes:MPMAttributeTop | MPMAttributeLeft | MPMAttributeRight | MPMAttributeBottom];
}

- (MPMConstraint *)size {
    return [self addConstraintWithAttributes:MPMAttributeWidth | MPMAttributeHeight];
}

- (MPMConstraint *)center {
    return [self addConstraintWithAttributes:MPMAttributeCenterX | MPMAttributeCenterY];
}

#pragma mark - grouping

- (MPMConstraint *(^)(dispatch_block_t group))group {
    return ^id(dispatch_block_t group) {
        NSInteger previousCount = self.constraints.count;
        group();

        NSArray *children = [self.constraints subarrayWithRange:NSMakeRange(previousCount, self.constraints.count - previousCount)];
        MPMCompositeConstraint *constraint = [[MPMCompositeConstraint alloc] initWithChildren:children];
        constraint.delegate = self;
        return constraint;
    };
}

@end
