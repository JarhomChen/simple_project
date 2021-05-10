//
//  PromptString.h
//  EPProject
//
//  Created by Jarhom on 2019/2/13.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络请求相关提示语
 */
#define kPrompt_unConnectInternet  @"您的网络似乎断开了连接？！"

#define kPrompt_Network_So_Bad @"服务请求失败"

#define kPrompt_Timeout @"网络连接超时，等会儿再试试…"

#define kPrompt_Operate_Fail(op)  [NSString stringWithFormat:@"%@失败，请稍候重试~",op]

#define kPrompt_AccessToken_Expire @"登录信息失效"

#define kPrompt_UnLogin @"请先登录"


#define NNKey_UserLoginStatusChanged @"NNKey_UserLoginStatusChanged"

