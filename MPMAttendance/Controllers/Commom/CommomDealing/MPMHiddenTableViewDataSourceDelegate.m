//
//  MPMHiddenTableViewDataSourceDelegate.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/6/11.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMHiddenTableViewDataSourceDelegate.h"
#import "MPMGetPeopleModel.h"
#import "MPMHiddenTableViewDeleteCell.h"

@implementation MPMHiddenTableViewDataSourceDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.peoplesArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kTableViewHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PopUpCell";
    MPMHiddenTableViewDeleteCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MPMHiddenTableViewDeleteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MPMGetPeopleModel *model = self.peoplesArray[indexPath.row];
    cell.textLabel.text = model.name;
    
    __weak typeof(self) weakself = self;
    cell.deleteBlock = ^(UIButton *sender) {
        __strong typeof(weakself) strongself = weakself;
        if (strongself.delegate && [strongself.delegate respondsToSelector:@selector(hiddenTableView:deleteData:)]) {
            [strongself.delegate hiddenTableView:tableView deleteData:model];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hiddenTableView:deleteData:)]) {
        [self.delegate hiddenTableView:tableView deleteData:self.peoplesArray[indexPath.row]];
    }
}

@end
