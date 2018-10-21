//
//  MPMTaskEditView.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPMProcessTaskModel;
@class MPMBaseViewController;

@interface MPMTaskEditView : UIView

- (void)showWithModel:(MPMProcessTaskModel *)model destinyVC:(MPMBaseViewController *)destinyVC completeBlock:(void(^)(MPMProcessTaskModel *))completeBlock;
- (void)dismiss;

@end
