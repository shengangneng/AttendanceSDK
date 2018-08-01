//
//  MPMBaseViewController.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMButton.h"
#import "MPMSessionManager.h"

@interface MPMBaseViewController () <UIGestureRecognizerDelegate>

@end

@implementation MPMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNetworkMonitoring];
    [self statisticsControllerInitCount];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 设置左滑返回手势enabled
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

/** 添加网络监控 */
- (void)addNetworkMonitoring {
    [[MPMSessionManager shareManager] startNetworkMonitoringWithStatusChangeBlock:^(MPMNetworkReachabilityStatus status) {
        // 处理网络状态不可用的情况
    }];
}

/** 统计子类控制器被初始化的次数 */
- (void)statisticsControllerInitCount {
    NSMutableDictionary *mdic = [[[NSUserDefaults standardUserDefaults] objectForKey:kControllerInitCountDicKey] mutableCopy];
    if (!mdic) mdic = [NSMutableDictionary dictionary];
    NSNumber *count = [mdic objectForKey:NSStringFromClass([self class])] ? [mdic objectForKey:NSStringFromClass([self class])] : [NSNumber numberWithInteger:0];
    NSNumber *nowCount = [NSNumber numberWithInteger:(count.integerValue + 1)];
    mdic[NSStringFromClass([self class])] = nowCount;
//    DLog(@"%@",mdic);
    [[NSUserDefaults standardUserDefaults] setObject:mdic forKey:kControllerInitCountDicKey];
}

#pragma mark - Public Method

- (void)setupAttributes {
    self.view.backgroundColor = kWhiteColor;
}

- (void)setupSubViews {
}

- (void)setupConstraints {
}

- (void)setLeftBarButtonWithTitle:(NSString *)title action:(SEL)selector {
    UIButton *leftButton = [MPMButton normalButtonWithTitle:title titleColor:kWhiteColor bgcolor:kClearColor];
    [leftButton setImage:ImageName(@"statistics_back") forState:UIControlStateNormal];
    [leftButton setImage:ImageName(@"statistics_back") forState:UIControlStateHighlighted];
    leftButton.titleLabel.font = SystemFont(17);
    leftButton.frame = CGRectMake(0, 0, 50, 40);
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [leftButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)setRightBarButtonType:(BarButtonItemType)type title:(NSString *)title image:(UIImage *)image action:(SEL)selector {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (type == forBarButtonTypeTitle) {
        if (kIsNilString(title)) return;
        rightButton.titleLabel.font = SystemFont(17);
        [rightButton setTitle:title forState:UIControlStateNormal];
        [rightButton setTitle:title forState:UIControlStateHighlighted];
        [rightButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [rightButton setTitleColor:kWhiteColor forState:UIControlStateHighlighted];
    } else if (type == forBarButtonTypeImage) {
        if (!image) return;
        [rightButton setImage:image forState:UIControlStateNormal];
        [rightButton setImage:image forState:UIControlStateHighlighted];
    }
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)showAlertControllerToLogoutWithMessage:(NSString *)message
                                    sureAction:(void(^)(UIAlertAction *_Nonnull action))sureAction
                              needCancleButton:(BOOL)needCancelBtn {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof (UIAlertController *) weakAlert = alertController;
    UIAlertAction *sure;
    if (sureAction) {
        sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:sureAction];
    } else {
        sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakAlert dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    if (needCancelBtn) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [weakAlert dismissViewControllerAnimated:YES completion:nil];
        }];
        [weakAlert addAction:cancelAction];
    }
    
    [weakAlert addAction:sure];
    [self presentViewController:weakAlert animated:YES completion:nil];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

#pragma mark -

- (void)dealloc {
    DLog(@"%@ dealloc",self);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 以后可以考虑做监控有没有东西没有被释放的功能
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
