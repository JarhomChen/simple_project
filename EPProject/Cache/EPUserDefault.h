//
//  EPUserDefault.h
//  EPProject
//
//  Created by Jarhom on 2019/2/13.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EPUserDefault : NSObject
/**
 *  登录用户
 */
+ (void)saveLoginUserInfo:(NSDictionary *)info;
+ (NSDictionary *)getLoginUserInfo;

@end

NS_ASSUME_NONNULL_END
