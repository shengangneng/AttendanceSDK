//
//  MPMLoginViewController.m
//  MPMAtendence
//  登录页
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMLoginViewController.h"
#import "MPMMainTabBarViewController.h"
#import "MPMButton.h"
#import "MPMSessionManager.h"
#import "MPMShareUser.h"
#import "NSObject+MPMExtention.h"
#import "MPMOauthUser.h"

@interface MPMLoginViewController () <UITextFieldDelegate>
// Header
@property (nonatomic, strong) UIImageView *headerIcon;
@property (nonatomic, strong) UILabel *headerTitleLabel;
// Middle
@property (nonatomic, strong) UIImageView *middleBackgroundView;
@property (nonatomic, strong) UIView *middleUserView;
@property (nonatomic, strong) UIView *middlePassView;
@property (nonatomic, strong) UIView *middleCompView;
@property (nonatomic, strong) UIView *middleUserLine;
@property (nonatomic, strong) UIView *middlePassLine;
@property (nonatomic, strong) UIView *middleCompLine;
@property (nonatomic, strong) UIImageView *middleUserIconView;
@property (nonatomic, strong) UIImageView *middlePassIconView;
@property (nonatomic, strong) UIImageView *middleCompIconView;
@property (nonatomic, strong) UITextField *middleUserTextField;
@property (nonatomic, strong) UITextField *middlePassTextField;
@property (nonatomic, strong) UITextField *middleCompTextField;
@property (nonatomic, strong) UIButton *middlefastRegisterButton;
@property (nonatomic, strong) UIButton *middlefoggotenPassButton;
@property (nonatomic, strong) UIButton *middleLoginButton;
// bottom
@property (nonatomic, strong) UIImageView *bottomImageView;

@end

@implementation MPMLoginViewController


- (instancetype)initWithToken:(NSString *)token
                       userId:(NSString *)userId
                  companyCode:(NSString *)companyCode {
    self = [super init];
    if (self) {
        [MPMOauthUser shareOauthUser].lastRootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        [MPMOauthUser shareOauthUser].lastStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
        [MPMOauthUser shareOauthUser].lastCanPopViewController = self;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        /*
        if (kIsNilString(token) || kIsNilString(refreshToken) || kIsNilString(expiresIn)) {
            // 传入的参数如果为空，则直接跳回
            if (self.navigationController.navigationBar.hidden == YES) {
                self.navigationController.navigationBar.hidden = NO;
            }
            [self.navigationController popViewControllerAnimated:YES];
            [[MPMOauthUser shareOauthUser] clearData];
        } else {
         */
        [MPMOauthUser shareOauthUser].access_token = token;
        [MPMOauthUser shareOauthUser].token_type = @"Bearer";
        [MPMOauthUser shareOauthUser].user_id = userId;
        [MPMOauthUser shareOauthUser].company_code = companyCode;
//        }
    }
    return self;
}

- (void)defaultSetting {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [MPMProgressHUD setMaximumDismissTimeInterval:0.5];
    [MPMProgressHUD setDefaultMaskType:MPMProgressHUDMaskTypeBlack];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupSubviews];
        [self setupAttributes];
        [self setupConstraints];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 推进来的时候隐藏navigationBar，否则会有卡顿
    self.view.backgroundColor = kWhiteColor;
    self.navigationItem.title = @"考勤登录";
    if (self.navigationController) {
        self.navigationController.navigationBar.hidden = YES;
    }
    if (kIsNilString([MPMOauthUser shareOauthUser].access_token) || kIsNilString([MPMOauthUser shareOauthUser].user_id) || kIsNilString([MPMOauthUser shareOauthUser].company_code)) {
        NSLog(@"数据不能为空");
        [[MPMSessionManager shareManager] backWithExpire:NO];
    } else {
        [self defaultSetting];
        [self getPerrimitionV2];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    [self addHeaderIconAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setupSubviews {
    // add Header
    [self.view addSubview:self.headerIcon];
    [self.view addSubview:self.headerTitleLabel];
    // add Middle
    [self.view addSubview:self.middleBackgroundView];
    [self.middleBackgroundView addSubview:self.middleUserView];
    [self.middleBackgroundView addSubview:self.middlePassView];
    [self.middleBackgroundView addSubview:self.middleCompView];
    [self.middleBackgroundView addSubview:self.middlefastRegisterButton];
    [self.middleBackgroundView addSubview:self.middlefoggotenPassButton];
    [self.middleBackgroundView addSubview:self.middleLoginButton];
    [self.middleUserView addSubview:self.middleUserIconView];
    [self.middleUserView addSubview:self.middleUserTextField];
    [self.middleUserView addSubview:self.middleUserLine];
    [self.middlePassView addSubview:self.middlePassIconView];
    [self.middlePassView addSubview:self.middlePassTextField];
    [self.middlePassView addSubview:self.middlePassLine];
    [self.middleCompView addSubview:self.middleCompIconView];
    [self.middleCompView addSubview:self.middleCompTextField];
    [self.middleCompView addSubview:self.middleCompLine];
    // bottom
    [self.view addSubview:self.bottomImageView];
}

- (void)setupAttributes {
    self.view.backgroundColor = kWhiteColor;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroud:)]];
    // Target Action
    [self.middleLoginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.middlefastRegisterButton addTarget:self action:@selector(fastRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.middlefoggotenPassButton addTarget:self action:@selector(foggotenPass:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupConstraints {
    
    [self.headerIcon mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.headerTitleLabel.mpm_top).offset(-10);
        make.centerX.equalTo(self.view.mpm_centerX);
        make.width.equalTo(@(116));
        make.height.equalTo(@(120));
    }];
    
    [self.headerTitleLabel mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.middleBackgroundView.mpm_top).offset(-25);
        make.centerX.equalTo(self.view.mpm_centerX);
        make.height.equalTo(@(PX_H(50)));
    }];
    
    [self.middleBackgroundView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerX.equalTo(self.view.mpm_centerX);
        make.centerY.equalTo(self.view.mpm_centerY).offset(45);
        make.width.equalTo(@(PX_W(641)));
        make.height.equalTo(@(PX_H(687)));// 实际(顶部14，底部34，左右23）
    }];
    
    // username
    [self.middleUserView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.middlePassView.mpm_top).offset(-2);
        make.leading.equalTo(self.middleLoginButton.mpm_leading);
        make.trailing.equalTo(self.middleLoginButton.mpm_trailing);
        make.height.equalTo(@(PX_H(124)));
    }];
    
    [self.middleUserIconView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.middleUserLine.mpm_top).offset(-11);
        make.leading.equalTo(self.middleUserView.mpm_leading);
        make.width.equalTo(@(PX_H(35)));
        make.height.equalTo(@(PX_H(34)));
    }];
    
    [self.middleUserTextField mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.middleUserIconView.mpm_centerY);
        make.bottom.equalTo(self.middleUserLine.mpm_top).offset(-2);
        make.leading.equalTo(self.middleUserIconView.mpm_trailing).offset(PX_W(15));
        make.trailing.equalTo(self.middleUserView.mpm_trailing);
    }];
    
    [self.middleUserLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.middleUserView.mpm_bottom).offset(-3.5);
        make.leading.equalTo(self.middleLoginButton.mpm_leading);
        make.trailing.equalTo(self.middleLoginButton.mpm_trailing);
        make.height.equalTo(@0.5);
    }];
    
    // password
    [self.middlePassView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.middleCompView.mpm_top).offset(-2);
        make.leading.equalTo(self.middleLoginButton.mpm_leading);
        make.trailing.equalTo(self.middleLoginButton.mpm_trailing);
        make.height.equalTo(@(PX_H(124)));
    }];
    
    [self.middlePassIconView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.middlePassLine.mpm_bottom).offset(-10);
        make.leading.equalTo(self.middlePassView.mpm_leading);
        make.width.equalTo(@(PX_H(30)));
        make.height.equalTo(@(PX_H(36)));
    }];
    
    [self.middlePassTextField mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.middlePassIconView.mpm_centerY);
        make.bottom.equalTo(self.middlePassLine.mpm_top).offset(-2);
        make.leading.equalTo(self.middlePassIconView.mpm_trailing).offset(PX_W(15));
        make.trailing.equalTo(self.middlePassView.mpm_trailing);
    }];
    
    [self.middlePassLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.middlePassView.mpm_bottom).offset(-3.5);
        make.leading.equalTo(self.middlePassView.mpm_leading);
        make.trailing.equalTo(self.middlePassView.mpm_trailing);
        make.height.equalTo(@0.5);
    }];
    
    // company
    [self.middleCompView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.middleLoginButton.mpm_top).offset(-PX_H(75));
        make.leading.equalTo(self.middleLoginButton.mpm_leading);
        make.trailing.equalTo(self.middleLoginButton.mpm_trailing);
        make.height.equalTo(@(PX_H(124)));
    }];
    
    [self.middleCompIconView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.middleCompLine.mpm_bottom).offset(-10);
        make.leading.equalTo(self.middleLoginButton.mpm_leading);
        make.width.equalTo(@(PX_H(37)));
        make.height.equalTo(@(PX_H(36)));
    }];
    
    [self.middleCompTextField mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.centerY.equalTo(self.middleCompIconView.mpm_centerY);
        make.bottom.equalTo(self.middleCompLine.mpm_top).offset(-2);
        make.leading.equalTo(self.middleCompIconView.mpm_trailing).offset(PX_W(15));
        make.trailing.equalTo(self.middleLoginButton.mpm_trailing);
    }];
    
    [self.middleCompLine mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.middleCompView.mpm_bottom).offset(-3);
        make.leading.equalTo(self.middleCompIconView.mpm_leading);
        make.trailing.equalTo(self.middleLoginButton.mpm_trailing);
        make.height.equalTo(@0.5);
    }];
    
    // 快速注册、忘记密码
    [self.middlefastRegisterButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.middleCompView.mpm_bottom).offset((PX_W(15)));
        make.leading.equalTo(self.middleLoginButton.mpm_leading);
        make.width.equalTo(@(70));
        make.height.equalTo(@(PX_W(40)));
    }];
    
    [self.middlefoggotenPassButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.top.equalTo(self.middleCompView.mpm_bottom).offset((PX_W(15)));
        make.trailing.equalTo(self.middleLoginButton.mpm_trailing);
        make.width.equalTo(@70);
        make.height.equalTo(@(PX_W(40)));
    }];
    
    [self.middleLoginButton mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.bottom.equalTo(self.middleBackgroundView.mpm_bottom).offset(-PX_H(114));
        make.centerX.equalTo(self.middleBackgroundView.mpm_centerX);
        make.height.equalTo(@(PX_H(80)));
        make.leading.equalTo(self.middleBackgroundView.mpm_leading).offset(PX_W(65));
        make.trailing.equalTo(self.middleBackgroundView.mpm_trailing).offset(-PX_W(65));
    }];
    // bottom
    [self.bottomImageView mpm_makeConstraints:^(MPMConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@120.5);
    }];
}

#pragma mark - Target Action
- (void)login:(UIButton *)sender {
    [self.view endEditing:YES];
    if (kIsNilString(self.middleUserTextField.text)) {
        [MPMProgressHUD setMinimumDismissTimeInterval:0.5];
        [MPMProgressHUD showErrorWithStatus:@"请输入用户账号"];
        return;
    } else if (kIsNilString(self.middlePassTextField.text)) {
        [MPMProgressHUD showErrorWithStatus:@"请输入账户密码"];
        return;
    } else if (kIsNilString(self.middleCompTextField.text)) {
        [MPMProgressHUD showErrorWithStatus:@"请输入企业代码"];
        return;
    }
    NSString *url = MPMINTERFACE_OAUTH;
    [MPMSessionManager shareManager].managerV2.requestSerializer = [MPMHTTPRequestSerializer serializer];
    [[MPMSessionManager shareManager].managerV2.requestSerializer setAuthorizationHeaderFieldWithUsername:@"kaoqin_ios" password:@"mpm"];
    NSDictionary *params = @{@"grant_type":@"password",@"username":[NSString stringWithFormat:@"enterprise:%@:%@",self.middleCompTextField.text,self.middleUserTextField.text],@"password":self.middlePassTextField.text};
    
    [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:NO params:params loadingMessage:@"正在登录" success:^(id response) {
        DLog(@"%@",response);
        MPMOauthUser *user = [[MPMOauthUser alloc] initWithDictionary:response];
        // 记录token过期时间（减去60秒）
        user.expires_in = [NSString stringWithFormat:@"%.f",[NSDate date].timeIntervalSince1970 + user.expires_in.doubleValue - 60];
        user.password = self.middlePassTextField.text;
        user.company_code = self.middleCompTextField.text;
        [self getPerrimitionV2];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

- (void)autoLogin {
    static BOOL canEnter = YES;
    @synchronized(self){
        if (canEnter) {
            canEnter = NO;
            if ([[MPMOauthUser shareOauthUser] getUserFromCoreData]) {
                NSString *url = MPMINTERFACE_OAUTH;
                NSString *username = [MPMOauthUser shareOauthUser].login_name;
                NSString *password = [MPMOauthUser shareOauthUser].password;
                NSString *companycode = [MPMOauthUser shareOauthUser].company_code;
                [MPMSessionManager shareManager].managerV2.requestSerializer = [MPMHTTPRequestSerializer serializer];
                [[MPMSessionManager shareManager].managerV2.requestSerializer setAuthorizationHeaderFieldWithUsername:@"kaoqin_ios" password:@"mpm"];
                NSDictionary *params = @{@"grant_type":@"password",@"username":[NSString stringWithFormat:@"enterprise:%@:%@",companycode,username],@"password":kSafeString(password)};
                [[MPMSessionManager shareManager] postRequestWithURL:url setAuth:NO params:params loadingMessage:@"正在登录" success:^(id response) {
                    DLog(@"%@",response);
                    canEnter = YES;
                    MPMOauthUser *user = [[MPMOauthUser alloc] initWithDictionary:response];
                    user.expires_in = [NSString stringWithFormat:@"%.f",[NSDate date].timeIntervalSince1970 + user.expires_in.doubleValue - 60];
                    user.password = self.middlePassTextField.text;
                    user.company_code = self.middleCompTextField.text;
                    [self getPerrimitionV2];
                    [self getCurrentUserMessage];
                } failure:^(NSString *error) {
                    DLog(@"%@",error);
                    canEnter = YES;
                    kAppDelegate.window.rootViewController = [[MPMLoginViewController alloc] init];
                    [[MPMShareUser shareUser] clearData];
                }];
            } else {
                canEnter = YES;
            }
        } else {
            return;
        }
    }
}

- (void)getPerrimitionV2 {
    NSString *url = [NSString stringWithFormat:@"%@%@",MPMINTERFACE_HOST,MPMINTERFACE_MYRES];
    NSLog(@"获取菜单中...");
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        NSLog(@"获取菜单成功%@",response);
        if (response[kResponseDataKey] && [response[kResponseDataKey] isKindOfClass:[NSDictionary class]] && kRequestSuccess == ((NSString *)response[kResponseDataKey][kCode]).integerValue) {
            [self getCurrentUserMessage];
            [MPMOauthUser shareOauthUser].perimissionArray = response[kResponseObjectKey];
            [[MPMOauthUser shareOauthUser] saveOrUpdateUserToCoreData];
            kAppDelegate.window.rootViewController = [[MPMMainTabBarViewController alloc] init];
        } else {
            [MPMProgressHUD showErrorWithStatus:@"获取菜单失败"];
        }
    } failure:^(NSString *error) {
        NSLog(@"获取菜单失败...");
        [MPMProgressHUD showErrorWithStatus:error];
    }];
}

- (void)getCurrentUserMessage {
    NSString *url = [NSString stringWithFormat:@"%@%@?userId=%@&companyCode=%@",MPMINTERFACE_EMDM,MPMINTERFACE_EMDM_CURRENTUSER,[MPMOauthUser shareOauthUser].user_id,[MPMOauthUser shareOauthUser].company_code];
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        NSLog(@"%@",response);
        if (response[kResponseObjectKey] && [response[kResponseObjectKey] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *object = response[kResponseObjectKey];
            [MPMOauthUser shareOauthUser].employee_id = object[@"employeeId"];
            [MPMOauthUser shareOauthUser].company_id = object[@"companyId"];
            [MPMOauthUser shareOauthUser].department_id = object[@"departmentId"];
            [MPMOauthUser shareOauthUser].department_name = object[@"departmentName"];
            [MPMOauthUser shareOauthUser].name_cn = object[@"username"];
            [[MPMOauthUser shareOauthUser] saveOrUpdateUserToCoreData];
            [self getCompanyNameWithCompanyCode:[MPMOauthUser shareOauthUser].company_code];
        }
    } failure:^(NSString *error) {
        NSLog(@"获取用户信息失败...%@--%@",[MPMOauthUser shareOauthUser].user_id,[MPMOauthUser shareOauthUser].company_code);
        [MPMProgressHUD showErrorWithStatus:error];
    }];
}

- (void)getCompanyNameWithCompanyCode:(NSString *)comCode {
    if (kIsNilString(comCode)) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"%@%@?companyCode=%@",MPMINTERFACE_EMDM,MPMINTERFACE_EMDM_COMPANY,comCode];
    [[MPMSessionManager shareManager] getRequestWithURL:url setAuth:YES params:nil loadingMessage:nil success:^(id response) {
        DLog(@"%@",response);
        if (response[kResponseDataKey] && [response[kResponseDataKey] isKindOfClass:[NSDictionary class]] && ((NSString *)response[kResponseDataKey][kCode]).integerValue == 200 && [response[kResponseObjectKey] isKindOfClass:[NSArray class]]) {
            NSDictionary *object = ((NSArray *)response[kResponseObjectKey]).firstObject;
            [MPMOauthUser shareOauthUser].shortName = object[@"shortName"];
            [MPMOauthUser shareOauthUser].fullName = object[@"fullName"];
        }
    } failure:^(NSString *error) {
        DLog(@"获取公司失败");
    }];
}

- (void)fastRegister:(UIButton *)sender {
    DLog(@"%@",@"fastRegister");
}

- (void)foggotenPass:(UIButton *)sender {
    DLog(@"%@",@"foggotenPass");
}

- (void)qqlogin:(UIButton *)sender {
    DLog(@"%@",@"qqlogin");
}

- (void)wclogin:(UIButton *)sender {
    DLog(@"%@",@"wclogin");
}

- (void)sinalogin:(UIButton *)sender {
    DLog(@"%@",@"sinalogin");
}

- (void)tapBackgroud:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.middleUserTextField.isFirstResponder) {
        [self.middlePassTextField becomeFirstResponder];
    } else if (self.middlePassTextField.isFirstResponder) {
        [self.middleCompTextField becomeFirstResponder];
    } else if (self.middleCompTextField.isFirstResponder) {
        [self login:self.middleLoginButton];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 如果修改用户名输入框，则清空密码框的内容
    if (textField == self.middleUserTextField && self.middlePassTextField.text.length > 0) {
        self.middlePassTextField.text = @"";
    }
    return YES;
}

#pragma mark - Keyboard Notification
- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    // 比较键盘高度和textfield的底部位置-设置键盘偏移
    NSDictionary *info = notification.userInfo;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ll;
    if (self.middleUserTextField.isFirstResponder) {
        ll = self.middleBackgroundView.frame.origin.y + PX_H(162);
    } else if (self.middlePassTextField.isFirstResponder){
        ll = self.middleBackgroundView.frame.origin.y + PX_H(286);
    } else {
        ll = self.middleBackgroundView.frame.origin.y + PX_H(415);
    }
    if (endKeyboardRect.origin.y < ll) {
        CGFloat delta = ll - endKeyboardRect.origin.y;
        CGAffineTransform pTransform = CGAffineTransformMakeTranslation(0, -delta);
        [UIView animateWithDuration:duration animations:^{
            self.view.transform = pTransform;
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            self.view.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark - Lazy Init

///////////////////////////////////////////////////////////////////////////////////////

- (UIImageView *)headerIcon {
    if (!_headerIcon) {
        _headerIcon = [[UIImageView alloc] init];
        _headerIcon.image = ImageName(@"login_logo");
    }
    return _headerIcon;
}

- (UILabel *)headerTitleLabel {
    if (!_headerTitleLabel) {
        _headerTitleLabel = [[UILabel alloc] init];
        [_headerTitleLabel sizeToFit];
        _headerTitleLabel.textAlignment = NSTextAlignmentCenter;
        _headerTitleLabel.text = @"群艺积分制考勤欢迎你!";
        _headerTitleLabel.textColor = kMainBlueColor;
        _headerTitleLabel.font = SystemFont(PX_W(40));
    }
    return _headerTitleLabel;
}

///////////////////////////////////////////////////////////////////////////////////////

- (UIImageView *)middleBackgroundView {
    if (!_middleBackgroundView) {
        _middleBackgroundView = [[UIImageView alloc] init];
        _middleBackgroundView.image = ImageName(@"login_bg_big_roundedrectangle");
        _middleBackgroundView.userInteractionEnabled = YES;
    }
    return _middleBackgroundView;
}

- (UIView *)middleUserView {
    if (!_middleUserView) {
        _middleUserView = [[UIView alloc] init];
    }
    return _middleUserView;
}

- (UIView *)middlePassView {
    if (!_middlePassView) {
        _middlePassView = [[UIView alloc] init];
    }
    return _middlePassView;
}

- (UIView *)middleCompView {
    if (!_middleCompView) {
        _middleCompView = [[UIView alloc] init];
    }
    return _middleCompView;
}

- (UIImageView *)middleUserIconView {
    if (!_middleUserIconView) {
        _middleUserIconView = [[UIImageView alloc] init];
        _middleUserIconView.image = ImageName(@"login_user");
    }
    return _middleUserIconView;
}

- (UIImageView *)middlePassIconView {
    if (!_middlePassIconView) {
        _middlePassIconView = [[UIImageView alloc] init];
        _middlePassIconView.image = ImageName(@"login_password");
    }
    return _middlePassIconView;
}

- (UIImageView *)middleCompIconView {
    if (!_middleCompIconView) {
        _middleCompIconView = [[UIImageView alloc] init];
        _middleCompIconView.image = ImageName(@"login_company");
    }
    return _middleCompIconView;
}

- (UITextField *)middleUserTextField {
    if (!_middleUserTextField) {
        _middleUserTextField = [[UITextField alloc] init];
        _middleUserTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _middleUserTextField.placeholder = @"请输入用户账号";
        _middleUserTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _middleUserTextField.tintColor = kMainBlueColor;
        _middleUserTextField.font = SystemFont(PX_W(32));
        _middleUserTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_middleUserTextField.placeholder attributes:@{NSForegroundColorAttributeName: kLoginLightGray}];
        _middleUserTextField.delegate = self;
    }
    return _middleUserTextField;
}

- (UITextField *)middlePassTextField {
    if (!_middlePassTextField) {
        _middlePassTextField = [[UITextField alloc] init];
        _middlePassTextField.placeholder = @"请输入账户密码";
        _middlePassTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _middlePassTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _middlePassTextField.tintColor = kMainBlueColor;
        _middlePassTextField.font = SystemFont(PX_W(32));
        _middlePassTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_middlePassTextField.placeholder attributes:@{NSForegroundColorAttributeName: kLoginLightGray}];
        _middlePassTextField.secureTextEntry = YES;
        _middlePassTextField.delegate = self;
    }
    return _middlePassTextField;
}

- (UITextField *)middleCompTextField {
    if (!_middleCompTextField) {
        _middleCompTextField = [[UITextField alloc] init];
        _middleCompTextField.placeholder = @"请输入企业代码";
        _middleCompTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _middleCompTextField.tintColor = kMainBlueColor;
        _middleCompTextField.font = SystemFont(PX_W(32));
        _middleCompTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_middleCompTextField.placeholder attributes:@{NSForegroundColorAttributeName: kLoginLightGray}];
        _middleCompTextField.delegate = self;
    }
    return _middleCompTextField;
}

- (UIView *)middleUserLine {
    if (!_middleUserLine) {
        _middleUserLine = [[UIView alloc] init];
        _middleUserLine.backgroundColor = kLightBlueColor;
    }
    return _middleUserLine;
}

- (UIView *)middlePassLine {
    if (!_middlePassLine) {
        _middlePassLine = [[UIView alloc] init];
        _middlePassLine.backgroundColor = kLightBlueColor;
    }
    return _middlePassLine;
}

- (UIView *)middleCompLine {
    if (!_middleCompLine) {
        _middleCompLine = [[UIView alloc] init];
        _middleCompLine.backgroundColor = kLightBlueColor;
    }
    return _middleCompLine;
}

- (UIButton *)middlefastRegisterButton {
    if (!_middlefastRegisterButton) {
        _middlefastRegisterButton = [MPMButton normalButtonWithTitle:@"快速注册" titleColor:kMainLightGray bgcolor:kWhiteColor];
        _middlefastRegisterButton.hidden = YES;
        _middlefastRegisterButton.titleLabel.font = SystemFont(PX_W(30));
    }
    return _middlefastRegisterButton;
}

- (UIButton *)middlefoggotenPassButton {
    if (!_middlefoggotenPassButton) {
        _middlefoggotenPassButton = [MPMButton normalButtonWithTitle:@"忘记密码" titleColor:kMainLightGray bgcolor:kWhiteColor];
        _middlefoggotenPassButton.hidden = YES;
        _middlefoggotenPassButton.titleLabel.font = SystemFont(PX_W(30));
    }
    return _middlefoggotenPassButton;
}

- (UIButton *)middleLoginButton {
    if (!_middleLoginButton) {
        _middleLoginButton = [MPMButton titleButtonWithTitle:@"登录" nTitleColor:kWhiteColor hTitleColor:kWhiteColor nBGImage:ImageName(@"login_btn_rounded") hImage:ImageName(@"login_btn_rounded")];
    }
    return _middleLoginButton;
}

///////////////////////////////////////////////////////////////////////////////////////
- (UIImageView *)bottomImageView {
    if (!_bottomImageView) {
        _bottomImageView = [[UIImageView alloc] init];
        _bottomImageView.image = ImageName(@"login_bottom");
    }
    return _bottomImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
