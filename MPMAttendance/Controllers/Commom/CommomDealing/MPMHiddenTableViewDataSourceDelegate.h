//
//  MPMHiddenTableViewDataSourceDelegate.h
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/11.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMAttendanceHeader.h"

@class MPMGetPeopleModel;
@protocol MPMHiddenTabelViewDelegate<NSObject>

- (void)hiddenTableView:(UITableView *)tableView deleteData:(MPMGetPeopleModel *)people;

@end

@interface MPMHiddenTableViewDataSourceDelegate : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<MPMGetPeopleModel *> *peoplesArray;
@property (nonatomic, weak) id<MPMHiddenTabelViewDelegate> delegate;

@end
