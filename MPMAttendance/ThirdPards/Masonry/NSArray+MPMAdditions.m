//
//  NSArray+MPMAdditions.m
//  
//
//  Created by Daniel Hammond on 11/26/13.
//
//

#import "NSArray+MPMAdditions.h"
#import "View+MPMAdditions.h"

@implementation NSArray (MPMAdditions)

- (NSArray *)mpm_makeConstraints:(void(^)(MPMConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (MPM_VIEW *view in self) {
        NSAssert([view isKindOfClass:[MPM_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view mpm_makeConstraints:block]];
    }
    return constraints;
}

- (NSArray *)mpm_updateConstraints:(void(^)(MPMConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (MPM_VIEW *view in self) {
        NSAssert([view isKindOfClass:[MPM_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view mpm_updateConstraints:block]];
    }
    return constraints;
}

- (NSArray *)mpm_remakeConstraints:(void(^)(MPMConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (MPM_VIEW *view in self) {
        NSAssert([view isKindOfClass:[MPM_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view mpm_remakeConstraints:block]];
    }
    return constraints;
}

- (void)mpm_distributeViewsAlongAxis:(MPMAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    MPM_VIEW *tempSuperView = [self mpm_commonSuperviewOfViews];
    if (axisType == MPMAxisTypeHorizontal) {
        MPM_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            MPM_VIEW *v = self[i];
            [v mpm_makeConstraints:^(MPMConstraintMaker *make) {
                if (prev) {
                    make.width.equalTo(prev);
                    make.left.equalTo(prev.mpm_right).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
    else {
        MPM_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            MPM_VIEW *v = self[i];
            [v mpm_makeConstraints:^(MPMConstraintMaker *make) {
                if (prev) {
                    make.height.equalTo(prev);
                    make.top.equalTo(prev.mpm_bottom).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }                    
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
}

- (void)mpm_distributeViewsAlongAxis:(MPMAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    MPM_VIEW *tempSuperView = [self mpm_commonSuperviewOfViews];
    if (axisType == MPMAxisTypeHorizontal) {
        MPM_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            MPM_VIEW *v = self[i];
            [v mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.width.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.right.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
    else {
        MPM_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            MPM_VIEW *v = self[i];
            [v mpm_makeConstraints:^(MPMConstraintMaker *make) {
                make.height.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.bottom.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
}

- (MPM_VIEW *)mpm_commonSuperviewOfViews
{
    MPM_VIEW *commonSuperview = nil;
    MPM_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[MPM_VIEW class]]) {
            MPM_VIEW *view = (MPM_VIEW *)object;
            if (previousView) {
                commonSuperview = [view mpm_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}

@end
