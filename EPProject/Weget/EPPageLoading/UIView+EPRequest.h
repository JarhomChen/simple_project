//
//  UIView+EPRequest.h
//  EPProject
//
//  Created by Jarhom on 2019/2/27.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPRequestView.h"

@interface UIView (EPRequest)

- (void)requestWithStatus:(TyLoadingStatus)status;

- (void)requestWithStatus:(TyLoadingStatus)status alpha:(CGFloat)alpha;

- (void)requestWithStatus:(TyLoadingStatus)status awayTop:(NSInteger)height;

- (void)hideRequestView;


#pragma mark - 自定义图标文字

- (void)setFailureTitle:(NSString *)title Icon:(UIImage *)image;

- (void)setNotResultTitle:(NSString *)title Icon:(UIImage *)image;

- (void)setNotLoginTitle:(NSString *)title Icon:(UIImage *)image;


//设置没有数据跳转block
- (void)setNotResultBlock:(void(^)(void))notResultBlock;

#pragma mark - failure
//设置重新加载block
- (void)setReloadBlock:(void(^)(void))reloadBlock;

@end
