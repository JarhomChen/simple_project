//
//  EPClient.h
//  EPProject
//
//  Created by Jarhom on 2019/2/13.
//  Copyright © 2019 Jarhom. All rights reserved.
//  app客户端全局单例

#import <Foundation/Foundation.h>
#import "EPUserModel.h"

#define EPUserMobile [EPClient shareInstance].loginUser.mobile

@interface EPClient : NSObject

//App启动或者唤醒时间
@property (nonatomic, strong) NSDate *wakeupDate;
//App 当前登录用户
@property (nonatomic, strong) EPUserModel *loginUser;

+ (instancetype)shareInstance;


#pragma mark - login
//loginUser的唯一set方法
+ (void)loginWithUser:(EPUserModel *)user;
//退出登录
+ (void)logout;
//保存当前用户
+ (void)saveCurrentUserLocal;
//没次启动用户自动登录
+ (void)userAutoLogin;
//判断登录状态  shouldLogin==YES时，未登录状态会弹出登录窗口
+ (BOOL)checkLoginStatus:(BOOL)shouldLogin;
//登录令牌
+ (NSString *)accessToken;
////是否已设置支付密码
//+ (BOOL)isSetPayPassword;
//刷新用户信息
+ (void)refreshUserInfoRetryTime:(NSInteger)retryTime
                        complete:(void(^)(BOOL isSucc, EPUserModel *user, NSString *msg))complete;


/**
 版本s更新

 @param alert 是否弹窗提示
 */
+ (void)checkAppVersionInfoWithRetryTime:(NSInteger)retry
                             shouldAlert:(BOOL)alert
                                complete:(void(^)(BOOL hasNew,NSString *url,NSString *version))complete;



@end
