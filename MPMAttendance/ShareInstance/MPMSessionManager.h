//
//  MPMHTTPSessionManager.h
//  MPMAtendence
//  网络请求单例
//  Created by gangneng shen on 2018/4/13.
//  Copyright © 2018年 gangneng shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMNetworking.h"

#define kResponseObjectKey  @"object"
#define kResponseDataKey    @"responseData"
#define kCode               @"code"
#define kMessage            @"message"

/** 一些常用的网络请求状态码 */
typedef NS_ENUM(NSInteger, MPMRequestStatusCode) {
    kRequestSuccess                 = 200,  /** 200:请求成功 */
    kRequestErrorBadRequest         = 400,  /** 400:语法错误，服务器无法理解 */
    kRequestErrorUnauthorized       = 401,  /** 401:未授权 */
    kRequestErrorNotFound           = 403,  /** 403:服务器已接收请求，但是拒绝执行 */
    kRequestErrorForbidden          = 404,  /** 404:资源不存在 */
    kRequestErrorMethodNotAllow     = 405,  /** 405:服务器不支持的请求方法 */
    kRequestErrorUnsupportType      = 415,  /** 415:不支持的类型 */
    kRequestErrorServerError        = 500,  /** 500:服务器内部错误 */
    kRequestErrorServiceUnavailable = 503,  /** 503:服务器正在维护或过载 */
};

@interface MPMSessionManager : NSObject

@property (nonatomic, strong) MPMHTTPSessionManager *managerV2;  /** 考勤2.0及之前版本 */

+ (instancetype)shareManager;

#pragma mark - V2.0

/** GET请求
 * @param setAuth YES则设置Authorization字段 NO则不设置
 * @param params 参数（数组或者字典）
 * @param loadingMessage 传值则弹出SVProgressHUD，传nil则不弹出SVProgressHUD
 * @param success 请求成功回调
 * @param failure 请求失败回调
 */
- (void)getRequestWithURL:(NSString *)url setAuth:(BOOL)setAuth params:(id)params loadingMessage:(NSString *)loadingMessage success:(void(^)(id response))success failure:(void(^)(NSString *error))failure;

/** POST请求
 * @param setAuth YES则设置Authorization字段 NO则不设置
 * @param params 参数（数组或者字典）
 * @param loadingMessage 传值则弹出SVProgressHUD，传nil则不弹出SVProgressHUD
 * @param success 请求成功回调
 * @param failure 请求失败回调
 */
- (void)postRequestWithURL:(NSString *)url setAuth:(BOOL)setAuth params:(id)params loadingMessage:(NSString *)loadingMessage success:(void(^)(id response))success failure:(void(^)(NSString *error))failure;

/** DELETE请求
 * @param setAuth YES则设置Authorization字段 NO则不设置
 * @param params 参数（数组或者字典）
 * @param loadingMessage 传值则弹出SVProgressHUD，传nil则不弹出SVProgressHUD
 * @param success 请求成功回调
 * @param failure 请求失败回调
 */
- (void)deleteRequestWithURL:(NSString *)url setAuth:(BOOL)setAuth params:(id)params loadingMessage:(NSString *)loadingMessage success:(void(^)(id response))success failure:(void(^)(NSString *error))failure;

- (void)backWithExpire:(BOOL)expire alertMessage:(NSString *)message;

@end
