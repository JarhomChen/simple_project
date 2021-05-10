//
//  EPProgressHUD.m
//  gmq
//
//  Created by jarhom on 2018/7/13.
//  Copyright © 2018年 GMQ. All rights reserved.
//

#import "EPProgressHUD.h"
#import <SVProgressHUD/SVProgressHUD.h>


@implementation EPProgressHUD

+ (void)configureUI {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeFlat];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
}




#pragma mark - toast 无图
+ (void)EP_showInfo:(NSString *)text {
    [EPProgressHUD EP_hideProgressHUD];
    if (!text) return;
    [SVProgressHUD showImage:nil status:text];
}

+ (void)EP_showInfo:(NSString *)text delay:(NSTimeInterval)delay {
    [EPProgressHUD EP_hideProgressHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showImage:nil status:text];
    });
}


#pragma mark - toast 带成功图标
+ (void)EP_showSuccessInfo:(NSString *)text {
    [EPProgressHUD EP_hideProgressHUD];
    if (!text) return;
    [SVProgressHUD showSuccessWithStatus:text];
}
+ (void)EP_showSuccessInfo:(NSString *)text delay:(NSTimeInterval)delay {
    [EPProgressHUD EP_hideProgressHUD];
    if (!text) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:text];
    });
}


#pragma mark - toast 带失败图标
+ (void)EP_showFailureInfo:(NSString *)text {
    
    [EPProgressHUD EP_hideProgressHUD];
    
    if (!text) return;

    [SVProgressHUD showErrorWithStatus:text];
}
+ (void)EP_showFailureInfo:(NSString *)text delay:(NSTimeInterval)delay {
    [EPProgressHUD EP_hideProgressHUD];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:text];
    });
}

#pragma mark - 加载状态
/**
 *  ProgressHUD
 */
+ (void)EP_showProgressHUD:(NSString *)text {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:text];
    
}

+ (void)EP_hideProgressHUD {
    [SVProgressHUD dismiss];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];

}


@end
