//
//  MPMHTTPSessionManager.h
//  MPMAtendence
//  网络请求单例
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface MPMHTTPSessionManager : NSObject

@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (instancetype)shareManager;

/** 在后台线程监控网络状态 */
- (void)startNetworkMonitoringWithStatusChangeBlock:(void(^)(AFNetworkReachabilityStatus status))block;

/** 带有SVProgressHUD的GET请求 */
- (void)getRequestWithURL:(NSString *)url params:(id)params loadingMessage:(NSString *)loadingMessage success:(void(^)(id response))success failure:(void(^)(NSString *error))failure;
/** 带有SVProgressHUD的POST请求 */
- (void)postRequestWithURL:(NSString *)url params:(id)params loadingMessage:(NSString *)loadingMessage success:(void(^)(id response))success failure:(void(^)(NSString *error))failure;

/** 不带SVProgressHUD的GET请求 */
- (void)getRequestWithURL:(NSString *)url params:(id)params success:(void(^)(id response))success failure:(void(^)(NSString *error))failure;
/** 不带SVProgressHUD的POST请求 */
- (void)postRequestWithURL:(NSString *)url params:(id)params success:(void(^)(id response))success failure:(void(^)(NSString *error))failure;

@end
