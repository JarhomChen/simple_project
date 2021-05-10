//
//  EPClient.m
//  EPProject
//
//  Created by Jarhom on 2019/2/13.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "EPClient.h"
#import "EPUserDefault.h"
#import "AppDelegate.h"

@implementation EPClient

+ (instancetype)shareInstance {
    
    static EPClient *_shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _shareInstance = [[EPClient alloc] init];
    });
    
    return _shareInstance;
}

#pragma mark - login
//loginUser的唯一set方法
+ (void)loginWithUser:(EPUserModel *)user {
    /*其他登录前逻辑*/
    [EPClient shareInstance].loginUser = user;
    [[EPNetwork shareInstance] refreshRequestHeader];
    [[NSNotificationCenter defaultCenter] postNotificationName:NNKey_UserLoginStatusChanged object:nil];
    [self refreshUserInfoRetryTime:3 complete:nil];
    
    //保存用户登录信息
    [EPClient saveCurrentUserLocal];

}
//退出登录
+ (void)logout {

    [EPClient shareInstance].loginUser = nil;
    [[EPNetwork shareInstance] refreshRequestHeader];
    [EPClient saveCurrentUserLocal];
    /*登出逻辑*/
    [[NSNotificationCenter defaultCenter] postNotificationName:NNKey_UserLoginStatusChanged object:nil];

}

//保存当前用户
+ (void)saveCurrentUserLocal {
    EPUserModel *user = [EPClient shareInstance].loginUser;
    if (user && user.uid && user.is_set_address) {
        NSDictionary *info = @{@"uid":user.uid,
                               @"access_token":user.access_token,
                               @"is_set_address":@(user.is_set_address)};
        [EPUserDefault saveLoginUserInfo:info];
    } else {
        [EPUserDefault saveLoginUserInfo:nil];
    }
}
//自动登录
+ (void)userAutoLogin {
    NSDictionary *info = [EPUserDefault getLoginUserInfo];
    if (!info) {
        return;
    }
    EPUserModel *user = [EPUserModel yy_modelWithJSON:info];
    if (user && user.uid && user.is_set_address) {
        [EPClient loginWithUser:user];
//        [EPClient refreshUserInfo:^(BOOL isSucc, EPUser *user, NSString *msg) {}];
    }
}

//判断登录状态  shouldLogin==YES时，未登录状态会弹出登录窗口
+ (BOOL)checkLoginStatus:(BOOL)shouldLogin{
    if ([EPClient shareInstance].loginUser.uid
        && [EPClient shareInstance].loginUser.access_token) {
        return YES;
    }
    
    if (shouldLogin) {
//        __weak __typeof(self) weakSelf = self;
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [UIAlertController showAlertInViewController:delegate.window.rootViewController withTitle:@"请先登录！" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"立即登录" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                //
                [[EPRooterManager shareInstance] gotoLoginViewController];
            }
        }];
    }
    
    return NO;
}

//登录令牌
+ (NSString *)accessToken {
    return [EPClient shareInstance].loginUser.access_token?:nil;
}

////是否已设置支付密码
//+ (BOOL)isSetPayPassword {
//
//    return [EPClient shareInstance].loginUser.is_set_psw;
//}

//刷新用户信息
+ (void)refreshUserInfoRetryTime:(NSInteger)retryTime
                        complete:(void(^)(BOOL isSucc, EPUserModel *user, NSString *msg))complete {
    
    if (retryTime<=0) {
        if(complete) complete(NO,nil,@"");
        return;
    }
    
    if (![EPClient checkLoginStatus:NO]) {
        complete(NO,nil,@"请登录");
        return;
    }
    
    
//    [[EPNetwork shareInstance] userGetUserInfoWithSuccess:^(NSInteger status, NSDictionary *data, NSString *msg) {
//        if (status != 1) {
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [EPClient refreshUserInfoRetryTime:retryTime-1 complete:complete];
//            });
//            return ;
//        }
//
//        EPUserModel *user = [EPClient shareInstance].loginUser;
//        [user yy_modelSetWithJSON:data];
//
//        if(complete) complete(YES, user, msg);
//    }];

}


/**
 版本s更新
 
 @param alert 是否弹窗提示
 */
+ (void)checkAppVersionInfoWithRetryTime:(NSInteger)retry
                             shouldAlert:(BOOL)alert
                                complete:(void(^)(BOOL hasNew,NSString *url,NSString *version))complete{
    
    if (retry<=0) {
        complete(NO,nil,nil);
        return;
    }
    
//    [[EPNetwork shareInstance] configversionInfoWithSuccess:^(NSInteger status, NSDictionary *data, NSString *msg) {
//        if (status != 1) {
//            
//            [EPClient checkAppVersionInfoWithRetryTime:retry-1 shouldAlert:alert complete:complete];
//            return ;
//        }
//        
//        
//        NSString *version_ios = [data objectForKey:@"version_ios"];
//        NSString *version_ios_url = [data objectForKey:@"ios_url"];
//        //        NSString *version_ios_upgrade = [data objectForKey:@"force_update"];
//        NSString *version_ios_explain = [data objectForKey:@"ios_explain"];
//        
//        NSString *version = [[UIApplication sharedApplication] appVersion];
//        BOOL hasNew = ![version isEqualToString:version_ios];
//        BOOL forceUpdate = [[data objectForKey:@"force_update"] boolValue];
//        
//        
//        if (complete) {
//            complete([version isEqualToString:version_ios],version_ios_url,version_ios);
//        }
//        
//        
//        if (hasNew) {
//            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            
//            [UIAlertController showAlertInViewController:delegate.window.rootViewController withTitle:@"版本更新" message:version_ios_explain cancelButtonTitle:(forceUpdate? nil:@"暂不更新") destructiveButtonTitle: @"立即更新" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
//                if (buttonIndex == 1) {
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:version_ios_url]];
//                }
//            }];
//        } else {
//            if (alert) {
//                [EPProgressHUD EP_showInfo:@"已经是最新版本！"];
//            }
//        }
//    }];
}


@end
