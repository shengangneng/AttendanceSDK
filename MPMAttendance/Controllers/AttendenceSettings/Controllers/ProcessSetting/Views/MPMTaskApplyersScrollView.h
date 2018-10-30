//
//  MPMTaskApplyersScrollView.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/8/28.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPMTaskApplyersDelegate <NSObject>

- (void)taskApplyersDidDeleteParticipants:(NSArray *)participants;

@end

@interface MPMTaskApplyersScrollView : UIScrollView

@property (nonatomic, weak) id<MPMTaskApplyersDelegate> delegate;
@property (nonatomic, copy) NSArray *participants;

@end
