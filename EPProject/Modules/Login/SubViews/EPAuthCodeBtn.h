//
//  EPAuthCodeBtn.h
//  EPProject
//
//  Created by Jarhom on 2019/2/17.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EPAuthCodeBtn : UIButton
//是否正在倒计时
@property (readonly, nonatomic, assign) BOOL isCounting;
//是否已点击获取验证码
@property (nonatomic, assign) BOOL hadSendAuthCode;

- (void)startCountTimer;

- (void)stopCountTimer;

@end

NS_ASSUME_NONNULL_END
