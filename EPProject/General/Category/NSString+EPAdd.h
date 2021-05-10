//
//  NSString+EPAdd.h
//  EPProject
//
//  Created by Jarhom on 2019/2/17.
//  Copyright © 2019 Jarhom. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface NSString (EPAdd)

//是否1开头的11位手机号
- (BOOL)validatePhoneNO ;

//是否纯数字额字符串
- (BOOL)validatePureDigitalWithCapacity:(NSInteger)capacity;

//判断密码是否合法 6-12个字符(数字，字母，下划线)
- (BOOL)validatePassword ;

//判断密码是否合法 6-20个字符

- (BOOL)validateComplexPassword ;

//邮箱格式验证
- (BOOL)validateEmail ;



@end

NS_ASSUME_NONNULL_END
