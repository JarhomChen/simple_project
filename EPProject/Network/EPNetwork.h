//
//  EPNetwork.h
//  EPProject
//
//  Created by Jarhom on 2019/2/13.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef NS_ENUM(NSInteger, TyNetworkStatus) {
    TyNetworkStatus_NeedLogin = -10086,    //令牌过期或者未登录
    TyNetworkStatus_Failure = 0,   //业务失败
    TyNetworkStatus_Success = 1,   //成功
    TyNetworkStatus_UnConnect = 10000, //网络断开连接
    TyNetworkStatus_Timeout ,       //网络连接超时
    TyNetworkStatus_Bad_Network,    //网络太差
    TyNetworkStatus_BadResponse ,     //服务端端返回错误  包括http 5xx错误
    TyNetworkStatus_Cancel,         //请求已取消
    TyNetworkStatus_Other,
};

typedef NS_ENUM(NSInteger, TyNetworkMethod) {
    TyNetworkMethod_GET = 1,   //GET
    TyNetworkMethod_POST,  //POST
    TyNetworkMethod_PUT,   //PUT
    TyNetworkMethod_DELETE,    //Delete
};

//成功回调
typedef void(^EPNetworkCallBack)(NSInteger status, NSDictionary *data, NSString *msg);

NS_ASSUME_NONNULL_BEGIN

@interface EPNetwork : AFHTTPSessionManager

+ (instancetype)shareInstance;


- (void)refreshRequestHeader;

//常规网络请求
- (NSURLSessionDataTask *)requestWithMethod:(TyNetworkMethod)method
                                       path:(NSString *)path
                                      param:(NSDictionary *)param
                                   complete:(EPNetworkCallBack)complete;

//上传文件网络请求
- (NSURLSessionDataTask *)uploadFileWithPath:(NSString *)path
                                  param:(NSDictionary *)param
                   constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                    progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                     complete:(EPNetworkCallBack)complete;


#pragma mark - 登录注册

/**
 登录
 
 @param account 账号
 @param password 密码
 */
- (void)userLoginByAccount:(NSString *)account
                  password:(NSString *)password
                  complete:(EPNetworkCallBack)complete;



@end
NS_ASSUME_NONNULL_END
