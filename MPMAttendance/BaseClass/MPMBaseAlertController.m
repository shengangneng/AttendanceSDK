//
//  MPMBaseAlertController.m
//  MPMAtendence
//
//  Created by shengangneng on 2018/12/15.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseAlertController.h"
#import "MPMAttendanceHeader.h"

@interface MPMBaseAlertController ()

@end

@implementation MPMBaseAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view addSubview:self.deleteButton];
}

- (void)delete:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.hidden = NO;
        [_deleteButton addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.frame = CGRectMake(self.view.frame.size.width - 25, 5, 20, 20);
        [_deleteButton setImage:ImageName(@"approval_delete") forState:UIControlStateNormal];
        [_deleteButton setImage:ImageName(@"approval_delete") forState:UIControlStateHighlighted];
    }
    return _deleteButton;
}

@end
