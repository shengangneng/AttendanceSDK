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
#import "MPMHTTPSessionManager.h"
#import "MPMShareUser.h"
#import "MPMDepartment.h"
#import "NSObject+MPMExtention.h"
#import "MPMAttendanceHeader.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSubviews];
    [self setupAttributes];
    [self setupConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
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
    [SVProgressHUD setMaximumDismissTimeInterval:0.5];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    self.view.backgroundColor = kWhiteColor;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroud:)]];
    // Target Action
    [self.middleLoginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.middlefastRegisterButton addTarget:self action:@selector(fastRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.middlefoggotenPassButton addTarget:self action:@selector(foggotenPass:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupConstraints {
    
    [self.headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headerTitleLabel.mas_top).offset(-10);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@(116));
        make.height.equalTo(@(120));
    }];

    [self.headerTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.middleBackgroundView.mas_top).offset(-25);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@(PX_H(50)));
    }];
    
    [self.middleBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).offset(45);
        make.width.equalTo(@(PX_W(641)));
        make.height.equalTo(@(PX_H(687)));// 实际(顶部14，底部34，左右23）
    }];
    
    // username
    [self.middleUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.middlePassView.mas_top).offset(-2);
        make.leading.equalTo(self.middleLoginButton.mas_leading);
        make.trailing.equalTo(self.middleLoginButton.mas_trailing);
        make.height.equalTo(@(PX_H(124)));
    }];
    
    [self.middleUserIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.middleUserLine.mas_top).offset(-11);
        make.leading.equalTo(self.middleUserView.mas_leading);
        make.width.equalTo(@(PX_H(35)));
        make.height.equalTo(@(PX_H(34)));
    }];
    
    [self.middleUserTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.middleUserIconView.mas_centerY);
        make.bottom.equalTo(self.middleUserLine.mas_top).offset(-2);
        make.leading.equalTo(self.middleUserIconView.mas_trailing).offset(PX_W(15));
        make.trailing.equalTo(self.middleUserView.mas_trailing);
    }];
    
    [self.middleUserLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleUserView.mas_bottom).offset(-3.5);
        make.leading.equalTo(self.middleLoginButton.mas_leading);
        make.trailing.equalTo(self.middleLoginButton.mas_trailing);
        make.height.equalTo(@0.5);
    }];
    
    // password
    [self.middlePassView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.middleCompView.mas_top).offset(-2);
        make.leading.equalTo(self.middleLoginButton.mas_leading);
        make.trailing.equalTo(self.middleLoginButton.mas_trailing);
        make.height.equalTo(@(PX_H(124)));
    }];
    
    [self.middlePassIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.middlePassLine.mas_bottom).offset(-10);
        make.leading.equalTo(self.middlePassView.mas_leading);
        make.width.equalTo(@(PX_H(30)));
        make.height.equalTo(@(PX_H(36)));
    }];
    
    [self.middlePassTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.middlePassIconView.mas_centerY);
        make.bottom.equalTo(self.middlePassLine.mas_top).offset(-2);
        make.leading.equalTo(self.middlePassIconView.mas_trailing).offset(PX_W(15));
        make.trailing.equalTo(self.middlePassView.mas_trailing);
    }];
    
    [self.middlePassLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.middlePassView.mas_bottom).offset(-3.5);
        make.leading.equalTo(self.middlePassView.mas_leading);
        make.trailing.equalTo(self.middlePassView.mas_trailing);
        make.height.equalTo(@0.5);
    }];
    
    // company
    [self.middleCompView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.middleLoginButton.mas_top).offset(-PX_H(75));
        make.leading.equalTo(self.middleLoginButton.mas_leading);
        make.trailing.equalTo(self.middleLoginButton.mas_trailing);
        make.height.equalTo(@(PX_H(124)));
    }];
    
    [self.middleCompIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.middleCompLine.mas_bottom).offset(-10);
        make.leading.equalTo(self.middleLoginButton.mas_leading);
        make.width.equalTo(@(PX_H(37)));
        make.height.equalTo(@(PX_H(36)));
    }];
    
    [self.middleCompTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.middleCompIconView.mas_centerY);
        make.bottom.equalTo(self.middleCompLine.mas_top).offset(-2);
        make.leading.equalTo(self.middleCompIconView.mas_trailing).offset(PX_W(15));
        make.trailing.equalTo(self.middleLoginButton.mas_trailing);
    }];
    
    [self.middleCompLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.middleCompView.mas_bottom).offset(-3);
        make.leading.equalTo(self.middleCompIconView.mas_leading);
        make.trailing.equalTo(self.middleLoginButton.mas_trailing);
        make.height.equalTo(@0.5);
    }];
    
    // 快速注册、忘记密码
    [self.middlefastRegisterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleCompView.mas_bottom).offset((PX_W(15)));
        make.leading.equalTo(self.middleLoginButton.mas_leading);
        make.width.equalTo(@(70));
        make.height.equalTo(@(PX_W(40)));
    }];
    
    [self.middlefoggotenPassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleCompView.mas_bottom).offset((PX_W(15)));
        make.trailing.equalTo(self.middleLoginButton.mas_trailing);
        make.width.equalTo(@70);
        make.height.equalTo(@(PX_W(40)));
    }];
    
    [self.middleLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.middleBackgroundView.mas_bottom).offset(-PX_H(114));
        make.centerX.equalTo(self.middleBackgroundView.mas_centerX);
        make.height.equalTo(@(PX_H(80)));
        make.leading.equalTo(self.middleBackgroundView.mas_leading).offset(PX_W(65));
        make.trailing.equalTo(self.middleBackgroundView.mas_trailing).offset(-PX_W(65));
    }];
    // bottom
    [self.bottomImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.view);
        make.height.equalTo(@120.5);
    }];
}

#pragma mark - Target Action
- (void)login:(UIButton *)sender {
    [self.view endEditing:YES];
    if (kIsNilString(self.middleUserTextField.text)) {
        [SVProgressHUD setMinimumDismissTimeInterval:0.5];
        [SVProgressHUD showErrorWithStatus:@"请输入用户账号"];
        return;
    } else if (kIsNilString(self.middlePassTextField.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入账户密码"];
        return;
    } else if (kIsNilString(self.middleCompTextField.text)) {
        [SVProgressHUD showErrorWithStatus:@"请输入企业代码"];
        return;
    }
    NSString *url = [MPMHost stringByAppendingString:@"index"];
    NSDictionary *params = @{@"userName":self.middleUserTextField.text,@"password":self.middlePassTextField.text,@"companyCode":self.middleCompTextField.text};
    
    [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:params loadingMessage:@"正在登录" success:^(id response) {
        DLog(@"%@",response);
        NSDictionary *dic = response;
        NSDictionary *data = dic[@"dataObj"];
        // 登录后将数据存到user全局对象中。
        [[MPMShareUser shareUser] convertModelWithDictionary:data];
        [MPMShareUser shareUser].username = self.middleUserTextField.text;
        [MPMShareUser shareUser].password = self.middlePassTextField.text;
        [MPMShareUser shareUser].companyName = self.middleCompTextField.text;
        [self getPerrimition];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
    }];
}

- (void)autoLogin {
    static BOOL canEnter = YES;
    @synchronized(self){
        if(canEnter){
            canEnter = NO;
            if ([[MPMShareUser shareUser] getUserFromCoreData]) {
                NSString *url = [MPMHost stringByAppendingString:@"index"];
                NSString *username = [MPMShareUser shareUser].username;
                NSString *password = [MPMShareUser shareUser].password;
                NSString *companyName = [MPMShareUser shareUser].companyName;
                NSDictionary *params = @{@"userName":username,@"password":password,@"companyCode":companyName};
                
                [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:params success:^(id response) {
                    canEnter = YES;
                    DLog(@"%@",response);
                    NSDictionary *dic = response;
                    NSDictionary *data = dic[@"dataObj"];
                    [[MPMShareUser shareUser] clearData];
                    [MPMShareUser shareUser].username = username;
                    [MPMShareUser shareUser].password = password;
                    [MPMShareUser shareUser].companyName = companyName;
                    // 登录后将数据存到user全局对象中。
                    [[MPMShareUser shareUser] convertModelWithDictionary:data];
                    [self getPerrimition];
                } failure:^(NSString *error) {
                    canEnter = YES;
                    kAppDelegate.window.rootViewController = [[MPMLoginViewController alloc] init];
                    [[MPMShareUser shareUser] clearData];
                    DLog(@"%@",error);
                }];
            } else {
                canEnter = YES;
            }
        } else {
            return;
        }
    }
}

- (void)getPerrimition {
    NSString *url = [NSString stringWithFormat:@"%@ApproveController/getPerimssionList?employeeId=%@&token=%@",MPMHost,[MPMShareUser shareUser].employeeId,[MPMShareUser shareUser].token];
    [[MPMHTTPSessionManager shareManager] postRequestWithURL:url params:nil success:^(id response) {
        [MPMShareUser shareUser].perimissionArray = response[@"dataObj"];
        [[MPMShareUser shareUser] saveOrUpdateUserToCoreData];
        kAppDelegate.window.rootViewController = [[MPMMainTabBarViewController alloc] init];
    } failure:^(NSString *error) {
        DLog(@"%@",error);
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
