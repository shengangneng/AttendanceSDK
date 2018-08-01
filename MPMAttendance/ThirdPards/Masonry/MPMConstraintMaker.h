//
//  MPMConstraintMaker.h
//  MPMMasonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MPMConstraint.h"
#import "MPMUtilities.h"

typedef NS_OPTIONS(NSInteger, MPMAttribute) {
    MPMAttributeLeft = 1 << NSLayoutAttributeLeft,
    MPMAttributeRight = 1 << NSLayoutAttributeRight,
    MPMAttributeTop = 1 << NSLayoutAttributeTop,
    MPMAttributeBottom = 1 << NSLayoutAttributeBottom,
    MPMAttributeLeading = 1 << NSLayoutAttributeLeading,
    MPMAttributeTrailing = 1 << NSLayoutAttributeTrailing,
    MPMAttributeWidth = 1 << NSLayoutAttributeWidth,
    MPMAttributeHeight = 1 << NSLayoutAttributeHeight,
    MPMAttributeCenterX = 1 << NSLayoutAttributeCenterX,
    MPMAttributeCenterY = 1 << NSLayoutAttributeCenterY,
    MPMAttributeBaseline = 1 << NSLayoutAttributeBaseline,
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    MPMAttributeFirstBaseline = 1 << NSLayoutAttributeFirstBaseline,
    MPMAttributeLastBaseline = 1 << NSLayoutAttributeLastBaseline,
    
#endif
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
    
    MPMAttributeLeftMargin = 1 << NSLayoutAttributeLeftMargin,
    MPMAttributeRightMargin = 1 << NSLayoutAttributeRightMargin,
    MPMAttributeTopMargin = 1 << NSLayoutAttributeTopMargin,
    MPMAttributeBottomMargin = 1 << NSLayoutAttributeBottomMargin,
    MPMAttributeLeadingMargin = 1 << NSLayoutAttributeLeadingMargin,
    MPMAttributeTrailingMargin = 1 << NSLayoutAttributeTrailingMargin,
    MPMAttributeCenterXWithinMargins = 1 << NSLayoutAttributeCenterXWithinMargins,
    MPMAttributeCenterYWithinMargins = 1 << NSLayoutAttributeCenterYWithinMargins,

#endif
    
};

/**
 *  Provides factory methods for creating MPMConstraints.
 *  Constraints are collected until they are ready to be installed
 *
 */
@interface MPMConstraintMaker : NSObject

/**
 *	The following properties return a new MPMViewConstraint
 *  with the first item set to the makers associated view and the appropriate MPMViewAttribute
 */
@property (nonatomic, strong, readonly) MPMConstraint *left;
@property (nonatomic, strong, readonly) MPMConstraint *top;
@property (nonatomic, strong, readonly) MPMConstraint *right;
@property (nonatomic, strong, readonly) MPMConstraint *bottom;
@property (nonatomic, strong, readonly) MPMConstraint *leading;
@property (nonatomic, strong, readonly) MPMConstraint *trailing;
@property (nonatomic, strong, readonly) MPMConstraint *width;
@property (nonatomic, strong, readonly) MPMConstraint *height;
@property (nonatomic, strong, readonly) MPMConstraint *centerX;
@property (nonatomic, strong, readonly) MPMConstraint *centerY;
@property (nonatomic, strong, readonly) MPMConstraint *baseline;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) MPMConstraint *firstBaseline;
@property (nonatomic, strong, readonly) MPMConstraint *lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) MPMConstraint *leftMargin;
@property (nonatomic, strong, readonly) MPMConstraint *rightMargin;
@property (nonatomic, strong, readonly) MPMConstraint *topMargin;
@property (nonatomic, strong, readonly) MPMConstraint *bottomMargin;
@property (nonatomic, strong, readonly) MPMConstraint *leadingMargin;
@property (nonatomic, strong, readonly) MPMConstraint *trailingMargin;
@property (nonatomic, strong, readonly) MPMConstraint *centerXWithinMargins;
@property (nonatomic, strong, readonly) MPMConstraint *centerYWithinMargins;

#endif

/**
 *  Returns a block which creates a new MPMCompositeConstraint with the first item set
 *  to the makers associated view and children corresponding to the set bits in the
 *  MPMAttribute parameter. Combine multiple attributes via binary-or.
 */
@property (nonatomic, strong, readonly) MPMConstraint *(^attributes)(MPMAttribute attrs);

/**
 *	Creates a MPMCompositeConstraint with type MPMCompositeConstraintTypeEdges
 *  which generates the appropriate MPMViewConstraint children (top, left, bottom, right)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) MPMConstraint *edges;

/**
 *	Creates a MPMCompositeConstraint with type MPMCompositeConstraintTypeSize
 *  which generates the appropriate MPMViewConstraint children (width, height)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) MPMConstraint *size;

/**
 *	Creates a MASCompositeConstraint with type MASCompositeConstraintTypeCenter
 *  which generates the appropriate MASViewConstraint children (centerX, centerY)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) MPMConstraint *center;

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *  Whether or not to remove existing constraints prior to installing
 */
@property (nonatomic, assign) BOOL removeExisting;

/**
 *	initialises the maker with a default view
 *
 *	@param	view	any MASConstraint are created with this view as the first item
 *
 *	@return	a new MASConstraintMaker
 */
- (id)initWithView:(MPM_VIEW *)view;

/**
 *	Calls install method on any MASConstraints which have been created by this maker
 *
 *	@return	an array of all the installed MASConstraints
 */
- (NSArray *)install;

- (MPMConstraint * (^)(dispatch_block_t))group;

@end
