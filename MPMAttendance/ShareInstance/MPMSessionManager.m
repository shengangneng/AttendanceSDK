//
//  MPMHTTPSessionManager.m
//  MPMAtendence
//  网络请求单例
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import "MPMSessionManager.h"
#import "MPMLoginViewController.h"
#import "MPMOauthUser.h"
#import "MPMAttendanceHeader.h"

const CGFloat SVProgressDismissDuration = 0.15;

static MPMSessionManager *instance;
@interface MPMSessionManager()

@end

@implementation MPMSessionManager

- (instancetype)initManager {
    self = [super init];
    if (self) {
        self.managerV2 = [MPMHTTPSessionManager manager];
        self.managerV2.requestSerializer = [MPMHTTPRequestSerializer serializer];
        self.managerV2.responseSerializer = [MPMJSONResponseSerializer serializer];
    }
    return self;
}

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
         instance = [[MPMSessionManager alloc] initManager];
    });
    return instance;
}


#pragma mark - Public Method

/** 每次网络请求之前，都会判断token是否已经过期（如果token已经过期，则用RefreshToken去刷新token之后再继续请求；如果token没有过期，则继续请求） */
- (void)checkOrRefreshTokenWithCompleteBlock:(void(^)(void))block {
    typeof(block) strongBlock = block;
    if ([MPMOauthUser shareOauthUser].expires_in.doubleValue > [NSDate date].timeIntervalSince1970) {
        strongBlock();
        return;
    }
    static BOOL canEnter = YES;
    @synchronized(self) {
        if (canEnter) {
            canEnter = NO;
            NSString *url = MPMINTERFACE_OAUTH;
            [MPMSessionManager shareManager].managerV2.requestSerializer = [MPMHTTPRequestSerializer serializer];
            [[MPMSessionManager shareManager].managerV2.requestSerializer setAuthorizationHeaderFieldWithUsername:@"mpm24_ios" password:@"COa8vJuC928rRV6SX3Q9MOBdKY7Nn8tn"];
            if (kIsNilString([MPMOauthUser shareOauthUser].refresh_token)) {
                canEnter = YES;
                strongBlock();
                return;
            }
            NSDictionary *params = @{@"grant_type":@"refresh_token",@"refresh_token":[MPMOauthUser shareOauthUser].refresh_token};
            NSLog(@"刷新token的参数%@",params);
            // 用refresh token去刷新token，并更新过期时间
            [self.managerV2 POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                canEnter = YES;
                if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                    NSString *expires_in = kNumberSafeString(responseObject[@"expires_in"]);
                    [MPMOauthUser shareOauthUser].expires_in = [NSString stringWithFormat:@"%.f",[NSDate date].timeIntervalSince1970 + expires_in.doubleValue - 60];
                    [MPMOauthUser shareOauthUser].access_token = responseObject[@"access_token"];
                    [MPMOauthUser shareOauthUser].refresh_token = responseObject[@"refresh_token"];
                    [[MPMOauthUser shareOauthUser] saveOrUpdateUserToCoreData];
                }
                strongBlock();
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                canEnter = YES;
                NSLog(@"刷新token失败%@",error);
                strongBlock();
            }];
        } else {
            return;
        }
    }
}

#pragma mark - Public Method

/** GET请求 */
- (void)getRequestWithURL:(NSString *)url setAuth:(BOOL)setAuth params:(id)params loadingMessage:(NSString *)loadingMessage success:(void(^)(id response))success failure:(void(^)(NSString *error))failure {
    BOOL needHUD = !kIsNilString(loadingMessage);
    if (needHUD) {
        [MPMProgressHUD showWithStatus:loadingMessage];
    }
    if (setAuth) {
        [self.managerV2.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",[MPMOauthUser shareOauthUser].token_type,[MPMOauthUser shareOauthUser].access_token] forHTTPHeaderField:kAuthKey];
        [self.managerV2 GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            if (needHUD) {
                [MPMProgressHUD dismissWithDelay:SVProgressDismissDuration];
            }
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                success(responseObject);
            } else {
                failure([instance getAlertMessageFromError:nil]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (needHUD) {
                [MPMProgressHUD dismissWithDelay:SVProgressDismissDuration];
            }
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            if (responses.statusCode == kRequestErrorUnauthorized) {
                [self backWithExpire:YES alertMessage:nil];
            } else {
                failure([instance getAlertMessageFromError:error]);
            }
        }];
    } else {
        [self.managerV2 GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            if (needHUD) {
                [MPMProgressHUD dismissWithDelay:SVProgressDismissDuration];
            }
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                success(responseObject);
            } else {
                failure([instance getAlertMessageFromError:nil]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            if (needHUD) {
                [MPMProgressHUD dismissWithDelay:SVProgressDismissDuration];
            }
            if (responses.statusCode == kRequestErrorUnauthorized) {
                [self backWithExpire:YES alertMessage:nil];
            } else {
                failure([instance getAlertMessageFromError:error]);
            }
        }];
    }
}

/** POST请求 */
- (void)postRequestWithURL:(NSString *)url setAuth:(BOOL)setAuth params:(id)params loadingMessage:(NSString *)loadingMessage success:(void(^)(id response))success failure:(void(^)(NSString *error))failure {
    BOOL needHUD = !kIsNilString(loadingMessage);
    if (needHUD) {
        [MPMProgressHUD showWithStatus:loadingMessage];
    }
    if (setAuth) {
        [self.managerV2.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",[MPMOauthUser shareOauthUser].token_type,[MPMOauthUser shareOauthUser].access_token] forHTTPHeaderField:kAuthKey];
        [self.managerV2 POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            if (needHUD) {
                [MPMProgressHUD dismissWithDelay:SVProgressDismissDuration];
            }
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                success(responseObject);
            } else {
                failure([instance getAlertMessageFromError:nil]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            if (needHUD) {
                [MPMProgressHUD dismissWithDelay:SVProgressDismissDuration];
            }
            if (responses.statusCode == kRequestErrorUnauthorized) {
                [self backWithExpire:YES alertMessage:nil];
            } else {
                failure([instance getAlertMessageFromError:error]);
            }
        }];
    } else {
        [self.managerV2 POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            if (needHUD) {
                [MPMProgressHUD dismissWithDelay:SVProgressDismissDuration];
            }
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                success(responseObject);
            } else {
                failure([instance getAlertMessageFromError:nil]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            if (needHUD) {
                [MPMProgressHUD dismissWithDelay:SVProgressDismissDuration];
            }
            if (responses.statusCode == kRequestErrorUnauthorized) {
                [self backWithExpire:YES alertMessage:nil];
            } else {
                failure([instance getAlertMessageFromError:error]);
            }
        }];
    }
}

/** DELETE请求 */
- (void)deleteRequestWithURL:(NSString *)url setAuth:(BOOL)setAuth params:(id)params loadingMessage:(NSString *)loadingMessage success:(void(^)(id response))success failure:(void(^)(NSString *error))failure {
    BOOL needHUD = !kIsNilString(loadingMessage);
    if (needHUD) {
        [MPMProgressHUD showWithStatus:loadingMessage];
    }
    if (setAuth) {
        [self.managerV2.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",[MPMOauthUser shareOauthUser].token_type,[MPMOauthUser shareOauthUser].access_token] forHTTPHeaderField:kAuthKey];
        [self.managerV2 DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (needHUD) {
                [MPMProgressHUD dismissWithDelay:SVProgressDismissDuration];
            }
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                success(responseObject);
            } else {
                failure([instance getAlertMessageFromError:nil]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            if (needHUD) {
                [MPMProgressHUD dismissWithDelay:SVProgressDismissDuration];
            }
            if (responses.statusCode == kRequestErrorUnauthorized) {
                [self backWithExpire:YES alertMessage:nil];
            } else {
                failure([instance getAlertMessageFromError:error]);
            }
        }];
    } else {
        [self.managerV2 DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (needHUD) {
                [MPMProgressHUD dismissWithDelay:SVProgressDismissDuration];
            }
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                success(responseObject);
            } else {
                failure([instance getAlertMessageFromError:nil]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            if (needHUD) {
                [MPMProgressHUD dismissWithDelay:SVProgressDismissDuration];
            }
            if (responses.statusCode == kRequestErrorUnauthorized) {
                [self backWithExpire:YES alertMessage:nil];
            } else {
                failure([instance getAlertMessageFromError:error]);
            }
        }];
    }
}

- (NSString *)getAlertMessageFromError:(NSError *)error {
    if (!error) {
        return @"网络连接失败";
    } else {
        if (NSURLErrorNotConnectedToInternet == error.code) {
            return @"网络连接失败";
        } else if (NSURLErrorBadServerResponse == error.code) {
            return @"请求失败";
        } else if (NSURLErrorTimedOut == error.code) {
            return @"网络请求超时";
        } else if (NSURLErrorCannotConnectToHost == error.code) {
            return @"连接不上服务器";
        } else {
            return @"网络连接失败";
        }
    }
}

- (void)backWithExpire:(BOOL)expire alertMessage:(NSString *)message {
    UIViewController *lastRoot = [MPMOauthUser shareOauthUser].lastRootViewController;
    UIViewController *lastPop = [MPMOauthUser shareOauthUser].lastCanPopViewController;
    [MPMProgressHUD dismiss];
    kAppDelegate.window.rootViewController = lastRoot;
    // 推进来的时候隐藏了，现在需要取消隐藏
    if (lastPop.navigationController.navigationBar.hidden == YES) {
        lastPop.navigationController.navigationBar.hidden = NO;
    }
    [UIApplication sharedApplication].statusBarStyle = [MPMOauthUser shareOauthUser].lastStatusBarStyle;
    if ([lastPop isKindOfClass:[MPMLoginViewController class]] && ((MPMLoginViewController *)lastPop).delegate && [((MPMLoginViewController *)lastPop).delegate respondsToSelector:@selector(attendanceBackWithTokenExpire:alertMessage:)]) {
        [((MPMLoginViewController *)lastPop).delegate attendanceBackWithTokenExpire:expire alertMessage:message];
    }
    [lastPop.navigationController popViewControllerAnimated:YES];
    [[MPMOauthUser shareOauthUser] clearData];
}

@end
