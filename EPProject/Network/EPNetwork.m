//
//  EPNetwork.m
//  EPProject
//
//  Created by Jarhom on 2019/2/13.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "EPNetwork.h"




@implementation EPNetwork




+ (instancetype)shareInstance {
    static EPNetwork *_shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURL *baseURL = [NSURL URLWithString:kServerBaseURL];
        
        _shareInstance = [[EPNetwork alloc] initWithBaseURL:baseURL
                                       sessionConfiguration:configure];
        
        //系统自动切换环境=
        //        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //        securityPolicy.allowInvalidCertificates = YES;//是否允许使用自签名证书
        //        securityPolicy.validatesDomainName = NO;//是否需要验证域名，默认YES
        //        _shareInstance.securityPolicy = securityPolicy;
        
        
        _shareInstance.requestSerializer = [AFJSONRequestSerializer serializer];
        _shareInstance.responseSerializer = [AFJSONResponseSerializer serializer];
        [_shareInstance.reachabilityManager startMonitoring];
        _shareInstance.responseSerializer.acceptableContentTypes  =  [NSSet setWithObjects:@"application/json", nil];
        _shareInstance.requestSerializer.timeoutInterval = 30;
        [_shareInstance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_shareInstance.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        UIDevice* currentDevice = [UIDevice currentDevice];
        NSString* appVer = [[UIApplication sharedApplication] appVersion];
        NSString* deviceOs = @"iOS";
        NSString* deviceName = currentDevice.machineModelName;
        NSString* osVersion = @([UIDevice systemVersion]).stringValue;
        
//        NSString* signString = [NSString stringWithFormat:@"app-ver=%@&device-os=%@&device-ver=%@&os-ver=%@", appVer, deviceOs, deviceName, osVersion];
//        NSString* sign = [AESCrypt encrypt:signString password:API_AES_KEY];
//        [_shareInstance.requestSerializer setValue:sign forHTTPHeaderField:@"sign"];

        [_shareInstance.requestSerializer setValue:appVer forHTTPHeaderField:@"app-ver"];
        [_shareInstance.requestSerializer setValue:deviceOs forHTTPHeaderField:@"device-os"];
        [_shareInstance.requestSerializer setValue:osVersion forHTTPHeaderField:@"os-ver"];
        [_shareInstance.requestSerializer setValue:deviceName forHTTPHeaderField:@"device-ver"];
        
        
    });
    
    return _shareInstance;
}

//登录状态变化需要更新token
- (void)refreshRequestHeader {
    
    if ([EPClient checkLoginStatus:NO]) {
        [self.requestSerializer setValue:[EPClient accessToken] forHTTPHeaderField:@"access-token"];
        DLog(@"accessToken %@",[EPClient accessToken]);
    } else {
        [self.requestSerializer setValue:nil forHTTPHeaderField:@"access-token"];
    }
}



//常规网络请求
- (NSURLSessionDataTask *)requestWithMethod:(TyNetworkMethod)method
                                       path:(NSString *)path
                                      param:(NSDictionary *)param
                                   complete:(EPNetworkCallBack)complete
{
    //请求完成
    void(^requestComplete)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            complete (TyNetworkStatus_Failure, nil, @"api数据有误");
            return ;
        }
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        NSDictionary *data = [result objectForKey:@"data"];
        NSString *msg = [result objectForKey:@"msg"];
        
        if (status == -10086) {  //code = -10086时，退到首页弹出登录框
            [EPClient logout];
            [[EPRooterManager shareInstance] gotoHomePage];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[EPRooterManager shareInstance] gotoLoginViewController];
            });
            complete (TyNetworkStatus_Failure, nil, msg);
            return ;
        }
        
        complete (status, data, msg);
    };
    
    //请求失败
    void(^requestFailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 
        if (error.code == kCFURLErrorCancelled) {
            return;
        }
        //超时
        if (error.code == kCFURLErrorTimedOut) {
            complete(TyNetworkStatus_Timeout, nil, kPrompt_Timeout);
            return ;
        }
        //网络中断
        if (error.code == kCFURLErrorNotConnectedToInternet) {
            complete(TyNetworkStatus_UnConnect, nil, kPrompt_unConnectInternet);
            return;
        }
        //网络异常
        if (error.code == kCFURLErrorBadServerResponse) {
            if ([AFNetworkReachabilityManager sharedManager].reachable) {
                complete(TyNetworkStatus_Bad_Network, nil, kPrompt_Network_So_Bad);
                return;
            }
        }
        
        complete(TyNetworkStatus_Other, nil, kPrompt_Operate_Fail(@"操作"));
        
    };
    
    
    //签名
    NSString *sign = [self constructureSignWithParams:param];
    [self.requestSerializer setValue:sign forHTTPHeaderField:@"signature"];
    
    

    if (method == TyNetworkMethod_GET) {
        return [self GET:path parameters:param progress:nil success:requestComplete failure:requestFailureBlock];
    } else if (method == TyNetworkMethod_POST) {
        return [self POST:path parameters:param progress:nil success:requestComplete failure:requestFailureBlock];
    } else if (method == TyNetworkMethod_PUT) {
        return [self PUT:path parameters:param success:requestComplete failure:requestFailureBlock];
    } else if (method == TyNetworkMethod_DELETE) {
        return [self DELETE:path parameters:param success:requestComplete failure:requestFailureBlock];
    }
    return nil;
}


//上传文件网络请求
- (NSURLSessionDataTask *)uploadFileWithPath:(NSString *)path
                                       param:(NSDictionary *)param
                   constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                    progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress
                                     complete:(EPNetworkCallBack)complete {
    
    //请求完成
    void(^requestComplete)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            complete (TyNetworkStatus_Failure, nil, @"api数据有误");
            return ;
        }
        
        NSDictionary *result = (NSDictionary *)responseObject;
        NSInteger status = [[result objectForKey:@"status"] integerValue];
        NSDictionary *data = [result objectForKey:@"data"];
        NSString *msg = [result objectForKey:@"msg"];
        
        if (status == -10086) {  //code = -10086时，退到首页弹出登录框
            [EPClient logout];
            [[EPRooterManager shareInstance] gotoHomePage];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[EPRooterManager shareInstance] gotoLoginViewController];
            });
            complete (TyNetworkStatus_Failure, nil, msg);
            return ;
        }
        
        complete (status, data, msg);
    };
    
    //请求失败
    void(^requestFailureBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error.code == kCFURLErrorCancelled) {
            return;
        }
        //超时
        if (error.code == kCFURLErrorTimedOut) {
            complete(TyNetworkStatus_Timeout, nil, kPrompt_Timeout);
            return ;
        }
        //网络中断
        if (error.code == kCFURLErrorNotConnectedToInternet) {
            complete(TyNetworkStatus_UnConnect, nil, kPrompt_unConnectInternet);
            return;
        }
        //网络异常
        if (error.code == kCFURLErrorBadServerResponse) {
            if ([AFNetworkReachabilityManager sharedManager].reachable) {
                complete(TyNetworkStatus_Bad_Network, nil, kPrompt_Network_So_Bad);
                return;
            }
        }
        
        complete(TyNetworkStatus_Other, nil, kPrompt_Operate_Fail(@"操作"));
        
    };
    
    //签名
    NSString *sign = [self constructureSignWithParams:param];
    [self.requestSerializer setValue:sign forHTTPHeaderField:@"signature"];
    
    return [self POST:path parameters:param constructingBodyWithBlock:block progress:uploadProgress success:requestComplete failure:requestFailureBlock];
}

- (NSString *)constructureSignWithParams:(NSDictionary *)param {
    
    //salt+bodyString+headerString+salt=>md5=>AES
//
//    NSString *salt = @"yxsoft";
//    NSMutableString *mString = [[NSMutableString alloc] initWithString:salt];
//
//
//    //body string
//    NSArray *allkeys = [[param allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        return [obj1 compare:obj2];
//    }];
//
//    for (NSString *key in allkeys) {
//        [mString appendFormat:@"%@%@",key,[param objectForKey:key]];
//    }
//
//
//    //headerString
//    if ([self.requestSerializer valueForHTTPHeaderField:@"access-token"]) {
//        [mString appendFormat:@"access-token%@",[self.requestSerializer valueForHTTPHeaderField:@"access-token"]];
//    }
//    [mString appendFormat:@"app-ver%@",[self.requestSerializer valueForHTTPHeaderField:@"app-ver"]];
//    [mString appendFormat:@"device-os%@",[self.requestSerializer valueForHTTPHeaderField:@"device-os"]];
//    [mString appendFormat:@"device-ver%@",[self.requestSerializer valueForHTTPHeaderField:@"device-ver"]];
//    [mString appendFormat:@"os-ver%@",[self.requestSerializer valueForHTTPHeaderField:@"os-ver"]];

    
    
    
//    [mString appendString:salt];
////    DLog(@"加密前：%@",mString);
//
//    NSString *md5 = [mString md5];
////    DLog(@"md5后：%@",md5);
//
//    NSString *aesString = [AESCrypt encrypt:md5 password:API_AES_KEY];
////    DLog(@"AES CBC模式加密后：%@",aesString);
    
    return [NSString new];
    
}


#pragma mark - 登录注册

/**
 登录
 
 @param account 账号
 @param password 密码
 */
- (void)userLoginByAccount:(NSString *)account
                  password:(NSString *)password
                  complete:(EPNetworkCallBack)complete {
    
    [self requestWithMethod:TyNetworkMethod_POST
                       path:@"/api/user/loginByAccount"
                      param:@{@"account":account,
                              @"password":password}
                   complete:complete];
    
}


@end

