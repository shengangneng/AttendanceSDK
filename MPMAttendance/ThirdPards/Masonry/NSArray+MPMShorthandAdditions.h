//
//  NSArray+MPMShorthandAdditions.h
//  MPMMasonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "NSArray+MPMAdditions.h"

#ifdef MPM_SHORTHAND

/**
 *	Shorthand array additions without the 'mpm_' prefixes,
 *  only enabled if MPM_SHORTHAND is defined
 */
@interface NSArray (MPMShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(MPMConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(MPMConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(MPMConstraintMaker *make))block;

@end

@implementation NSArray (MPMShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(MPMConstraintMaker *))block {
    return [self mpm_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(^)(MPMConstraintMaker *))block {
    return [self mpm_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(^)(MPMConstraintMaker *))block {
    return [self mpm_remakeConstraints:block];
}

@end

#endif
