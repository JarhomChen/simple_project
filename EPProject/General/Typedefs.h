//
//  Typedefs.h
//  EPProject
//
//  Created by Jarhom on 2019/2/13.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import <Foundation/Foundation.h>

//验证码类型
typedef NS_ENUM(NSInteger, TyAuthCode) {
    TyAuthCode_Register = 1,//注册
    TyAuthCode_ForgetPwd,   //忘记密码
    TyAuthCode_BankBind,    //绑定银行卡
    TyAuthCode_Transfer,    //积分转让
    TyAuthCode_SetPayPwd,   //设置支付密码
    TyAuthCode_ForgetPayPwd //忘记支付密码
};



