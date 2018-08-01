//
//  UIViewController+MPMAdditions.m
//  MPMMasonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "ViewController+MPMAdditions.h"

#ifdef MPM_VIEW_CONTROLLER

@implementation MPM_VIEW_CONTROLLER (MPMAdditions)

- (MPMViewAttribute *)mpm_topLayoutGuide {
    return [[MPMViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (MPMViewAttribute *)mpm_topLayoutGuideTop {
    return [[MPMViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (MPMViewAttribute *)mpm_topLayoutGuideBottom {
    return [[MPMViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (MPMViewAttribute *)mpm_bottomLayoutGuide {
    return [[MPMViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (MPMViewAttribute *)mpm_bottomLayoutGuideTop {
    return [[MPMViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (MPMViewAttribute *)mpm_bottomLayoutGuideBottom {
    return [[MPMViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}



@end

#endif
