//
//  MASCompositeConstraint.h
//  Masonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "MPMConstraint.h"
#import "MPMUtilities.h"

/**
 *	A group of MPMConstraint objects
 */
@interface MPMCompositeConstraint : MPMConstraint

/**
 *	Creates a composite with a predefined array of children
 *
 *	@param	children	child MPMConstraints
 *
 *	@return	a composite constraint
 */
- (id)initWithChildren:(NSArray *)children;

@end
