//
//  NSString+EPAdd.m
//  EPProject
//
//  Created by Jarhom on 2019/2/17.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "NSString+EPAdd.h"

@implementation NSString (EPAdd)

//是否1开头的11位手机号
- (BOOL)validatePhoneNO {
    NSString * predicateFormat = @"^1\\d{10}";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", predicateFormat];
    
    return [predicate evaluateWithObject:self];
    
}

//是否纯数字额字符串
- (BOOL)validatePureDigitalWithCapacity:(NSInteger)capacity {
    
    NSString * predicateFormat = [NSString stringWithFormat:@"^[0-9]{%ld}", (long)capacity];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", predicateFormat];
    
    return [predicate evaluateWithObject:self];
}

/**
 *  判断密码是否合法 6-12个字符(数字，字母，下划线)
 *
 */
- (BOOL)validatePassword {
    
    NSString * predicateFormat = @"[A-Za-z0-9_]{6,12}";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", predicateFormat];
    BOOL isValid = [predicate evaluateWithObject:self];
    
    return isValid;
}

/**
 *  判断密码是否合法 6-20个字符
 *
 */
- (BOOL)validateComplexPassword {
    if (self.length < 6 || self.length >24) {
        return NO;
    }
    return YES;
    //    NSString * predicateFormat = @"([A-Za-z]+[^A-Za-z]+)|([\\d]+[\\D]+)|([\\W]+[\\w]+)";
    //    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", predicateFormat];
    //    return  [predicate evaluateWithObject:self];
}

//邮箱格式验证
- (BOOL)validateEmail {
    NSString * emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z0-9.-]{2,6}";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [predicate evaluateWithObject:self];
}

@end
