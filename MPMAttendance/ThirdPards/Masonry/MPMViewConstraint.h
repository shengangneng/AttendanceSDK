//
//  MASViewConstraint.h
//  Masonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MPMViewAttribute.h"
#import "MPMConstraint.h"
#import "MPMLayoutConstraint.h"
#import "MPMUtilities.h"

/**
 *  A single constraint.
 *  Contains the attributes neccessary for creating a NSLayoutConstraint and adding it to the appropriate view
 */
@interface MPMViewConstraint : MPMConstraint <NSCopying>

/**
 *	First item/view and first attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) MPMViewAttribute *firstViewAttribute;

/**
 *	Second item/view and second attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) MPMViewAttribute *secondViewAttribute;

/**
 *	initialises the MPMViewConstraint with the first part of the equation
 *
 *	@param	firstViewAttribute	view.mas_left, view.mas_width etc.
 *
 *	@return	a new view constraint
 */
- (id)initWithFirstViewAttribute:(MPMViewAttribute *)firstViewAttribute;

/**
 *  Returns all MPMViewConstraints installed with this view as a first item.
 *
 *  @param  view  A view to retrieve constraints for.
 *
 *  @return An array of MPMViewConstraints.
 */
+ (NSArray *)installedConstraintsForView:(MPM_VIEW *)view;

@end
