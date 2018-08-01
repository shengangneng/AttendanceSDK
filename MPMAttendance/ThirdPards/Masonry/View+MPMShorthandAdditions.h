//
//  UIView+MPMShorthandAdditions.h
//  MPMMasonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "View+MPMAdditions.h"

#ifdef MPM_SHORTHAND

/**
 *	Shorthand view additions without the 'mpm_' prefixes,
 *  only enabled if MPM_SHORTHAND is defined
 */
@interface MPM_VIEW (MPMShorthandAdditions)

@property (nonatomic, strong, readonly) MPMViewAttribute *left;
@property (nonatomic, strong, readonly) MPMViewAttribute *top;
@property (nonatomic, strong, readonly) MPMViewAttribute *right;
@property (nonatomic, strong, readonly) MPMViewAttribute *bottom;
@property (nonatomic, strong, readonly) MPMViewAttribute *leading;
@property (nonatomic, strong, readonly) MPMViewAttribute *trailing;
@property (nonatomic, strong, readonly) MPMViewAttribute *width;
@property (nonatomic, strong, readonly) MPMViewAttribute *height;
@property (nonatomic, strong, readonly) MPMViewAttribute *centerX;
@property (nonatomic, strong, readonly) MPMViewAttribute *centerY;
@property (nonatomic, strong, readonly) MPMViewAttribute *baseline;
@property (nonatomic, strong, readonly) MPMViewAttribute *(^attribute)(NSLayoutAttribute attr);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) MPMViewAttribute *firstBaseline;
@property (nonatomic, strong, readonly) MPMViewAttribute *lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) MPMViewAttribute *leftMargin;
@property (nonatomic, strong, readonly) MPMViewAttribute *rightMargin;
@property (nonatomic, strong, readonly) MPMViewAttribute *topMargin;
@property (nonatomic, strong, readonly) MPMViewAttribute *bottomMargin;
@property (nonatomic, strong, readonly) MPMViewAttribute *leadingMargin;
@property (nonatomic, strong, readonly) MPMViewAttribute *trailingMargin;
@property (nonatomic, strong, readonly) MPMViewAttribute *centerXWithinMargins;
@property (nonatomic, strong, readonly) MPMViewAttribute *centerYWithinMargins;

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

@property (nonatomic, strong, readonly) MPMViewAttribute *safeAreaLayoutGuideTop API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) MPMViewAttribute *safeAreaLayoutGuideBottom API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) MPMViewAttribute *safeAreaLayoutGuideLeft API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) MPMViewAttribute *safeAreaLayoutGuideRight API_AVAILABLE(ios(11.0),tvos(11.0));

#endif

- (NSArray *)makeConstraints:(void(^)(MPMConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(MPMConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(MPMConstraintMaker *make))block;

@end

#define MPM_ATTR_FORWARD(attr)  \
- (MPMViewAttribute *)attr {    \
    return [self mpm_##attr];   \
}

@implementation MPM_VIEW (MPMShorthandAdditions)

MPM_ATTR_FORWARD(top);
MPM_ATTR_FORWARD(left);
MPM_ATTR_FORWARD(bottom);
MPM_ATTR_FORWARD(right);
MPM_ATTR_FORWARD(leading);
MPM_ATTR_FORWARD(trailing);
MPM_ATTR_FORWARD(width);
MPM_ATTR_FORWARD(height);
MPM_ATTR_FORWARD(centerX);
MPM_ATTR_FORWARD(centerY);
MPM_ATTR_FORWARD(baseline);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

MPM_ATTR_FORWARD(firstBaseline);
MPM_ATTR_FORWARD(lastBaseline);

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

MPM_ATTR_FORWARD(leftMargin);
MPM_ATTR_FORWARD(rightMargin);
MPM_ATTR_FORWARD(topMargin);
MPM_ATTR_FORWARD(bottomMargin);
MPM_ATTR_FORWARD(leadingMargin);
MPM_ATTR_FORWARD(trailingMargin);
MPM_ATTR_FORWARD(centerXWithinMargins);
MPM_ATTR_FORWARD(centerYWithinMargins);

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

MPM_ATTR_FORWARD(safeAreaLayoutGuideTop);
MPM_ATTR_FORWARD(safeAreaLayoutGuideBottom);
MPM_ATTR_FORWARD(safeAreaLayoutGuideLeft);
MPM_ATTR_FORWARD(safeAreaLayoutGuideRight);

#endif

- (MPMViewAttribute *(^)(NSLayoutAttribute))attribute {
    return [self mpm_attribute];
}

- (NSArray *)makeConstraints:(void(NS_NOESCAPE ^)(MPMConstraintMaker *))block {
    return [self mpm_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(NS_NOESCAPE ^)(MPMConstraintMaker *))block {
    return [self mpm_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(NS_NOESCAPE ^)(MPMConstraintMaker *))block {
    return [self mpm_remakeConstraints:block];
}

@end

#endif
