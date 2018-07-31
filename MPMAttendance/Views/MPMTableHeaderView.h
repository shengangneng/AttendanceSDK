//
//  MPMTableHeaderView.h
//  MPMAtendence
//  通用的tableView的header或者footer
//  Created by shengangneng on 2018/5/15.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMTableHeaderView : UIView

@property (nonatomic, strong) UILabel *headerTextLabel;

/** 重设headerTextLabel的leading offset */
- (void)resetTextLabelLeadingOffser:(NSInteger)offset;

@end
