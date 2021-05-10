//
//  EPUser.h
//  EPProject
//
//  Created by Jarhom on 2019/2/18.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "EPModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EPUserModel : EPModel

//用户id
@property (nonatomic, strong) NSString *uid;
//是否完善资料
@property (nonatomic, assign) BOOL is_set_address;
//是否设置密码
@property (nonatomic, assign) BOOL is_set_psw;
//登录令牌
@property (nonatomic, strong) NSString *access_token;
//头像
@property (nonatomic, strong) NSString * avatar;
//邀请码
@property (nonatomic, strong) NSString *invite_code;
//手机号码
@property (nonatomic, strong) NSString *mobile;
//真实姓名
@property (nonatomic, strong) NSString *realname;
//省id
@property (nonatomic) NSInteger provinceid;
@property (nonatomic, strong) NSString *province;
///市id
@property (nonatomic) NSInteger cityid;
@property (nonatomic, strong) NSString *city;
//区id
@property (nonatomic) NSInteger areaid;
@property (nonatomic, strong) NSString *area;
//详细地址
@property (nonatomic, strong) NSString *address_details;

//创建时间
@property (nonatomic, strong) NSString *create_time;

//会员等级
@property (nonatomic, strong) NSString *member;

@end

NS_ASSUME_NONNULL_END
