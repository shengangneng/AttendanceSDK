//
//  UIViewController+MPMAdditions.h
//  MPMMasonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "MPMUtilities.h"
#import "MPMConstraintMaker.h"
#import "MPMViewAttribute.h"

#ifdef MPM_VIEW_CONTROLLER

@interface MPM_VIEW_CONTROLLER (MPMAdditions)

/**
 *	following properties return a new MPMViewAttribute with appropriate UILayoutGuide and NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_topLayoutGuide;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_bottomLayoutGuide;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_topLayoutGuideTop;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_topLayoutGuideBottom;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_bottomLayoutGuideTop;
@property (nonatomic, strong, readonly) MPMViewAttribute *mpm_bottomLayoutGuideBottom;


@end

#endif
