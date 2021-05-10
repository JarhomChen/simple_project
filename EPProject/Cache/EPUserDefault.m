//
//  EPUserDefault.m
//  EPProject
//
//  Created by Jarhom on 2019/2/13.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "EPUserDefault.h"

#define UserDefault [NSUserDefaults standardUserDefaults]


@implementation EPUserDefault

/**
 *  登录用户
 */
+ (void)saveLoginUserInfo:(NSDictionary *)info {
    if (!info) {
        [UserDefault removeObjectForKey:@"UDKey_LoginUserInfo"];
    } else {
        [UserDefault setObject:info forKey:@"UDKey_LoginUserInfo"];
    }
    [UserDefault synchronize];
}

+ (NSDictionary *)getLoginUserInfo {
    NSDictionary *info = [UserDefault objectForKey:@"UDKey_LoginUserInfo"];
    return info;
}

@end
