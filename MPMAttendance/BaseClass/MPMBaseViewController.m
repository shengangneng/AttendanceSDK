//
//  MPMBaseViewController.m
//  MPMAtendence
//
//  Created by gangneng shen on 2018/4/22.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMBaseViewController.h"
#import "MPMButton.h"
#import "MPMOfflineView.h"
#import "MPMAttendanceHeader.h"

@interface MPMBaseViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) MPMOfflineView *offlineView;

@property (nonatomic, strong) id gNetBlock;

@end

@implementation MPMBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.offlineView];
    [self.offlineView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    __weak typeof(self) weakself = self;
    self.offlineView.reloadViewBlock = ^{
        __strong typeof(weakself) strongself = weakself;
        [strongself addNetworkMonitoringWithGoodNetworkBlock:strongself.gNetBlock];
    };
    [self statisticsControllerInitCount];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 设置左滑返回手势enabled
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

/** 添加网络监控 */
- (void)addNetworkMonitoringWithGoodNetworkBlock:(void(^)(void))gNetBlock {
    self.gNetBlock = gNetBlock;
    dispatch_async(kGlobalQueueDEFAULT, ^{
        __weak typeof(self) weakself = self;
        [self.checkNetworkManager setReachabilityStatusChangeBlock:^(MPMNetworkReachabilityStatus status) {
            __strong typeof(weakself) strongself = weakself;
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongself.checkNetworkManager stopMonitoring];
                if (status == MPMNetworkReachabilityStatusUnknown || status == MPMNetworkReachabilityStatusNotReachable) {
                    // 网络不可用：取消隐藏无网络视图
                    strongself.offlineView.state = kOfflineStateUnavailable;
                } else {
                    // 网络可用：隐藏无网络视图、告诉页面可以加载了、销毁引用的block
                    gNetBlock();
                    strongself.offlineView.state = kOfflineStateAvailable;
                    // 需要释放强引用的block
                    strongself.gNetBlock = nil;
                }
            });
        }];
        [self.checkNetworkManager startMonitoring];
    });
}

/** 统计子类控制器被初始化的次数 */
- (void)statisticsControllerInitCount {
    NSMutableDictionary *mdic = [[kUserDefaults objectForKey:kControllerInitCountDicKey] mutableCopy];
    if (!mdic) mdic = [NSMutableDictionary dictionary];
    NSNumber *count = [mdic objectForKey:NSStringFromClass([self class])] ? [mdic objectForKey:NSStringFromClass([self class])] : [NSNumber numberWithInteger:0];
    NSNumber *nowCount = [NSNumber numberWithInteger:(count.integerValue + 1)];
    mdic[NSStringFromClass([self class])] = nowCount;
    //    DLog(@"%@",mdic);
    [kUserDefaults setObject:mdic forKey:kControllerInitCountDicKey];
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
        [rightButton setTitle:title forState:UIControlStateSelected];
        [rightButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [rightButton setTitleColor:kWhiteColor forState:UIControlStateHighlighted];
        [rightButton setTitleColor:kWhiteColor forState:UIControlStateSelected];
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
    [self showAlertControllerToLogoutWithMessage:message sureAction:sureAction sureActionTitle:nil needCancleButton:needCancelBtn];
}

- (void)showAlertControllerToLogoutWithMessage:(NSString *)message
                                    sureAction:(void(^)(UIAlertAction *_Nonnull action))sureAction
                               sureActionTitle:(NSString *)sureActionTitle
                              needCancleButton:(BOOL)needCancelBtn {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof (UIAlertController *) weakAlert = alertController;
    UIAlertAction *sure;
    if (sureAction) {
        sure = [UIAlertAction actionWithTitle:sureActionTitle?sureActionTitle:@"确定" style:UIAlertActionStyleDefault handler:sureAction];
    } else {
        sure = [UIAlertAction actionWithTitle:sureActionTitle?sureActionTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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

- (MPMOfflineView *)offlineView {
    if (!_offlineView) {
        _offlineView = [[MPMOfflineView alloc] init];
        _offlineView.state = kOfflineStateAvailable;
        _offlineView.hidden = YES;
    }
    return _offlineView;
}

- (MPMNetworkReachabilityManager *)checkNetworkManager {
    if (!_checkNetworkManager) {
        _checkNetworkManager = [MPMNetworkReachabilityManager manager];
    }
    return _checkNetworkManager;
}

@end
