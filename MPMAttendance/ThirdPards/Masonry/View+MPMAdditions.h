//
//  UIView+MPMAdditions.h
//  MPMMasonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MPMUtilities.h"
#import "MPMConstraintMaker.h"
#import "MPMViewAttribute.h"

/**
 *	Provides constraint maker block
 *  and convience methods for creating MPMViewAttribute which are view + NSLayoutAttribute pairs
 */
@interface MPM_VIEW (MPMAdditions)

/**
 *	following properties return a new MPMViewAttribute with current view and appropriate NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_left;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_top;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_right;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_bottom;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_leading;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_trailing;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_width;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_height;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_centerX;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_centerY;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_baseline;
@property (nonatomic, strong, readonly) MPMViewAttribute *(^mpm_attribute)(NSLayoutAttribute attr);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_firstBaseline;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_leftMargin;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_rightMargin;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_topMargin;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_bottomMargin;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_leadingMargin;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_trailingMargin;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_centerXWithinMargins;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_centerYWithinMargins;

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_safeAreaLayoutGuide API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_safeAreaLayoutGuideTop API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_safeAreaLayoutGuideBottom API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_safeAreaLayoutGuideLeft API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_safeAreaLayoutGuideRight API_AVAILABLE(ios(11.0),tvos(11.0));

#endif

/**
 *	a key to associate with this view
 */
@property (nonatomic, strong) id mpm_key;

/**
 *	Finds the closest common superview between this view and another view
 *
 *	@param	view	other view
 *
 *	@return	returns nil if common superview could not be found
 */
- (instancetype)mpm_closestCommonSuperview:(MPM_VIEW *)view;

/**
 *  Creates a MPMConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created MPMConstraints
 */
- (NSArray *)mpm_makeConstraints:(void(NS_NOESCAPE ^)(MPMConstraintMaker *make))block;

/**
 *  Creates a MPMConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  If an existing constraint exists then it will be updated instead.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated MPMConstraints
 */
- (NSArray *)mpm_updateConstraints:(void(NS_NOESCAPE ^)(MPMConstraintMaker *make))block;

/**
 *  Creates a MPMConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated MPMConstraints
 */
- (NSArray *)mpm_remakeConstraints:(void(NS_NOESCAPE ^)(MPMConstraintMaker *make))block;

@end
