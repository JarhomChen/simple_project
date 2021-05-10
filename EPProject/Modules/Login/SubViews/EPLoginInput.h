//
//  EPLoginInputCell.h
//  EPProject
//
//  Created by Jarhom on 2019/2/17.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPAuthCodeBtn.h"

@protocol EPLoginInputDelegate <NSObject>

//提交
- (void)commitHandle:(UIButton *)btn;

//获取验证码
- (void)authCodeHandle:(EPAuthCodeBtn *)btn;

@end

NS_ASSUME_NONNULL_BEGIN

@interface EPLoginInput : NSObject

@property (nonatomic, weak) id <EPLoginInputDelegate> delegate;

//手机号输入框
@property (nonatomic, weak) IBOutlet UITextField *phoneTextfield;

//验证码输入
@property (nonatomic, weak) IBOutlet UITextField * authCodeTextfield;
//获取验证码按钮
@property (nonatomic, weak) IBOutlet EPAuthCodeBtn *authCodeBtn;

//密码输入框
@property (nonatomic, weak) IBOutlet UITextField *pwdTextfield;

//确认密码输入框
@property (nonatomic, weak) IBOutlet UITextField *repwdTextfield;


//登录、注册按钮
@property (nonatomic, weak) IBOutlet UIButton *commitBtn;


//验证所有信息
- (BOOL)checkAllInfo:(BOOL)shouldWarning;



@end

NS_ASSUME_NONNULL_END
