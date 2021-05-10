//
//  EPLoginInputCell.m
//  EPProject
//
//  Created by Jarhom on 2019/2/17.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "EPLoginInput.h"

@interface EPLoginInput ()<UITextFieldDelegate>

@end

@implementation EPLoginInput

- (void)setPhoneTextfield:(UITextField *)phoneTextfield {
    _phoneTextfield = phoneTextfield;
    phoneTextfield.delegate = self;
    [phoneTextfield addTarget:self
                       action:@selector(textfieldDidChanged:)
             forControlEvents:UIControlEventEditingChanged];

}

- (void)setPwdTextfield:(UITextField *)pwdTextfield {
    _pwdTextfield = pwdTextfield;
    pwdTextfield.delegate = self;
    [pwdTextfield addTarget:self
                     action:@selector(textfieldDidChanged:)
           forControlEvents:UIControlEventEditingChanged];
}


- (void)setCommitBtn:(UIButton *)commitBtn {
    _commitBtn = commitBtn;
    [commitBtn addTarget:self
                  action:@selector(commitBtnHandle:)
        forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xf3c952)]
                         forState:UIControlStateNormal];
    [commitBtn setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xD8D8D8)]
                         forState:UIControlStateDisabled];
    [commitBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateNormal];
    commitBtn.layer.cornerRadius = commitBtn.height/2.f;
    commitBtn.layer.masksToBounds = YES;
    
    
}

- (void)setAuthCodeBtn:(EPAuthCodeBtn *)authCodeBtn {
    _authCodeBtn = authCodeBtn;
    [authCodeBtn addTarget:self
                    action:@selector(authCodeBtnHandle:)
          forControlEvents:UIControlEventTouchUpInside];
}




- (void)commitBtnHandle:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(commitHandle:)]) {
        [self.delegate commitHandle:sender];
    }
}

- (void)authCodeBtnHandle:(EPAuthCodeBtn *)sender {
    
    if (![self.phoneTextfield.text length]) {
        [EPProgressHUD EP_showFailureInfo:@"请输入手机号码!"];
        return;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(authCodeHandle:)]) {
        [self.delegate authCodeHandle:sender];
    }
}


#pragma mark - UITextFieldDelegate <NSObject>

- (void)textFieldDidEndEditing:(UITextField *)textField{
//    self.commitBtn.enabled = [self checkAllInfo:NO];
}
//- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0); // if implemented, called in place of textFieldDidEndEditing:

- (void)textfieldDidChanged:(UITextField *)textfield {
    NSString *text = [textfield.text stringByTrim];
    if ([text length]>11 && textfield == _phoneTextfield) {
        textfield.text = [text substringToIndex:11];
    }
//    self.commitBtn.enabled = [self checkAllInfo:NO];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - private

- (BOOL)checkAllInfo:(BOOL)shouldWarning {
    NSString *phone = [self.phoneTextfield.text stringByTrim];
    if (![phone length]||![phone validatePhoneNO]) {
        if (shouldWarning) [EPProgressHUD EP_showFailureInfo:@"请输入11位正确手机号码"];
        return NO;
    }
    
    if (self.authCodeTextfield && ![[self.authCodeTextfield.text stringByTrim] length]) {
        if (shouldWarning) [EPProgressHUD EP_showFailureInfo:@"请输入验证码"];
        return NO;
    }
    
    NSString *pwd = [self.pwdTextfield.text stringByTrim];
    if (self.pwdTextfield
        && ![pwd validatePassword]) {
        if (shouldWarning) [EPProgressHUD EP_showFailureInfo:@"请输入6-12为登录密码，仅支持数字，字母和下划线"];
        return NO;
    }
    
    NSString *repwd = [self.repwdTextfield.text stringByTrim];
    if (self.repwdTextfield
        &&(![repwd length] || ![pwd isEqualToString:repwd])) {
        if (shouldWarning) [EPProgressHUD EP_showFailureInfo:@"两次密码输入不一致"];
        return NO;
    }
    
    return YES;
}


@end
