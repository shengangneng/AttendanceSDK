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
    @synchronized(self){
        if (canEnter) {
            canEnter = NO;
            NSString *url = MPMINTERFACE_OAUTH;
            [MPMSessionManager shareManager].managerV2.requestSerializer = [MPMHTTPRequestSerializer serializer];
            [[MPMSessionManager shareManager].managerV2.requestSerializer setAuthorizationHeaderFieldWithUsername:@"mpm24_ios" password:@"COa8vJuC928rRV6SX3Q9MOBdKY7Nn8tn"];
            NSDictionary *params = @{@"grant_type":@"refresh_token",@"refresh_token":[MPMOauthUser shareOauthUser].refresh_token};
            // 用refresh token去刷新token，并更新过期时间
            [self.managerV2 POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                canEnter = YES;
                MPMOauthUser *updateUser = [[MPMOauthUser alloc] initWithDictionary:responseObject];
                updateUser.expiresIn = updateUser.expires_in;
                updateUser.expires_in = [NSString stringWithFormat:@"%.f",[NSDate date].timeIntervalSince1970 + [MPMOauthUser shareOauthUser].expires_in.doubleValue - 60];
                [[MPMOauthUser shareOauthUser] saveOrUpdateUserToCoreData];
                strongBlock();
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                canEnter = YES;
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
        __weak typeof(self) weakself = self;
        [self checkOrRefreshTokenWithCompleteBlock:^{
            __strong typeof(weakself) strongself = weakself;
            [strongself.managerV2.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",[MPMOauthUser shareOauthUser].token_type,[MPMOauthUser shareOauthUser].access_token] forHTTPHeaderField:kAuthKey];
            [strongself.managerV2 GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    if (needHUD) {
                        [MPMProgressHUD dismiss];
                    }
                    success(responseObject);
                } else {
                    if (needHUD) {
                        [MPMProgressHUD showErrorWithStatus:@"返回数据格式不正确"];
                    }
                    failure(nil);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (needHUD) {
                    [MPMProgressHUD showErrorWithStatus:error.localizedDescription];
                }
                NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                if (responses.statusCode == kRequestErrorUnauthorized) {
                    [self back];
                } else {
                    failure(error.localizedDescription);
                }
            }];
        }];
    } else {
        [self.managerV2 GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (needHUD) {
                    [MPMProgressHUD dismiss];
                }
                success(responseObject);
            } else {
                if (needHUD) {
                    [MPMProgressHUD showErrorWithStatus:@"返回数据格式不正确"];
                }
                failure(nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            if (needHUD) {
                [MPMProgressHUD showErrorWithStatus:error.localizedDescription];
            }
            if (responses.statusCode == kRequestErrorUnauthorized) {
                [self back];
            } else {
                failure(error.localizedDescription);
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
        __weak typeof(self) weakself = self;
        [self checkOrRefreshTokenWithCompleteBlock:^{
            __strong typeof(weakself) strongself = weakself;
            [strongself.managerV2.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",[MPMOauthUser shareOauthUser].token_type,[MPMOauthUser shareOauthUser].access_token] forHTTPHeaderField:kAuthKey];
            [strongself.managerV2 POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    if (needHUD) {
                        [MPMProgressHUD dismiss];
                    }
                    success(responseObject);
                } else {
                    if (needHUD) {
                        [MPMProgressHUD showErrorWithStatus:@"返回数据格式不正确"];
                    }
                    failure(nil);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                if (needHUD) {
                    [MPMProgressHUD showErrorWithStatus:error.localizedDescription];
                }
                if (responses.statusCode == kRequestErrorUnauthorized) {
                    [self back];
                } else {
                    failure(error.localizedDescription);
                }
            }];
        }];
    } else {
        [self.managerV2 POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (needHUD) {
                    [MPMProgressHUD dismiss];
                }
                success(responseObject);
            } else {
                if (needHUD) {
                    [MPMProgressHUD showErrorWithStatus:@"返回数据格式不正确"];
                }
                failure(nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            if (needHUD) {
                [MPMProgressHUD showErrorWithStatus:error.localizedDescription];
            }
            if (responses.statusCode == kRequestErrorUnauthorized) {
                [self back];
            } else {
                failure(error.localizedDescription);
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
        __weak typeof(self) weakself = self;
        [self checkOrRefreshTokenWithCompleteBlock:^{
            __strong typeof(weakself) strongself = weakself;
            [strongself.managerV2.requestSerializer setValue:[NSString stringWithFormat:@"%@ %@",[MPMOauthUser shareOauthUser].token_type,[MPMOauthUser shareOauthUser].access_token] forHTTPHeaderField:kAuthKey];
            [strongself.managerV2 DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    if (needHUD) {
                        [MPMProgressHUD dismiss];
                    }
                    success(responseObject);
                } else {
                    if (needHUD) {
                        [MPMProgressHUD showErrorWithStatus:@"返回数据格式不正确"];
                    }
                    failure(nil);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
                [MPMProgressHUD showErrorWithStatus:error.localizedDescription];
                if (responses.statusCode == kRequestErrorUnauthorized) {
                    [self back];
                } else {
                    failure(error.localizedDescription);
                }
            }];
        }];
    } else {
        [self.managerV2 DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (needHUD) {
                    [MPMProgressHUD dismiss];
                }
                success(responseObject);
            } else {
                if (needHUD) {
                    [MPMProgressHUD showErrorWithStatus:@"返回数据格式不正确"];
                }
                failure(nil);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
            if (needHUD) {
                [MPMProgressHUD showErrorWithStatus:error.localizedDescription];
            }
            if (responses.statusCode == kRequestErrorUnauthorized) {
                [self back];
            } else {
                failure(error.localizedDescription);
            }
        }];
    }
}

- (void)back {
    UIViewController *lastRoot = [MPMOauthUser shareOauthUser].lastRootViewController;
    UIViewController *lastPop = [MPMOauthUser shareOauthUser].lastCanPopViewController;
    kAppDelegate.window.rootViewController = lastRoot;
    // 推进来的时候隐藏了，现在需要取消隐藏
    if (lastPop.navigationController.navigationBar.hidden == YES) {
        lastPop.navigationController.navigationBar.hidden = NO;
    }
    [UIApplication sharedApplication].statusBarStyle = [MPMOauthUser shareOauthUser].lastStatusBarStyle;
    if ([lastPop isKindOfClass:[MPMLoginViewController class]] && ((MPMLoginViewController *)lastPop).delegate && [((MPMLoginViewController *)lastPop).delegate respondsToSelector:@selector(attendanceDidCompleteWithToken:refreshToken:expiresIn:)]) {
        if (!kIsNilString([MPMOauthUser shareOauthUser].access_token) && !kIsNilString([MPMOauthUser shareOauthUser].refresh_token) && !kIsNilString([MPMOauthUser shareOauthUser].expiresIn)) {
            [((MPMLoginViewController *)lastPop).delegate attendanceDidCompleteWithToken:[MPMOauthUser shareOauthUser].access_token refreshToken:[MPMOauthUser shareOauthUser].refresh_token expiresIn:[MPMOauthUser shareOauthUser].expiresIn];
        }
    }
    [lastPop.navigationController popViewControllerAnimated:YES];
    [[MPMOauthUser shareOauthUser] clearData];
}

@end
