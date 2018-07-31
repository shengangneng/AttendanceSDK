//
//  MPMSiderDrawerCollectionViewTimeCell.h
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/26.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

#define StartButtonTag 777
#define EndButtonTag 888

@class MPMSiderDrawerCollectionViewTimeCell;

@protocol MPMSiderDrawerTimeCellDelegate<NSObject>

- (void)siderDrawerCell:(MPMSiderDrawerCollectionViewTimeCell *)cell didSelectStartTime:(UIButton *)sender;
- (void)siderDrawerCell:(MPMSiderDrawerCollectionViewTimeCell *)cell didSelectEndTime:(UIButton *)sender;

@end

@interface MPMSiderDrawerCollectionViewTimeCell : UICollectionViewCell

@property (nonatomic, weak) id<MPMSiderDrawerTimeCellDelegate> delegate;

@end
