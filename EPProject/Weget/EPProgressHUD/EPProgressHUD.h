//
//  EPProgressHUD.h
//  gmq
//
//  Created by jarhom on 2018/7/13.
//  Copyright © 2018年 GMQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JPToastBlock)(void);


@interface EPProgressHUD : NSObject


+ (void)configureUI;

#pragma mark - toast 无图
+ (void)EP_showInfo:(NSString *)text;
+ (void)EP_showInfo:(NSString *)text delay:(NSTimeInterval)delay;


#pragma mark - toast 带成功图标
+ (void)EP_showSuccessInfo:(NSString *)text;
+ (void)EP_showSuccessInfo:(NSString *)text delay:(NSTimeInterval)delay;


#pragma mark - toast 带失败图标
+ (void)EP_showFailureInfo:(NSString *)text;
+ (void)EP_showFailureInfo:(NSString *)text delay:(NSTimeInterval)delay;


#pragma mark - 加载状态
/**
 *  ProgressHUD
 */
+ (void)EP_showProgressHUD:(NSString *)text;

+ (void)EP_hideProgressHUD;


@end
