//
//  EPRequestView.h
//  EPProject
//
//  Created by Jarhom on 2019/2/27.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import <UIKit/UIKit.h>

//加载状态
typedef NS_ENUM(NSInteger, TyLoadingStatus) {
    TyLoadingStatus_None,
    TyLoadingStatus_Loading,       //加载中
    TyLoadingStatus_NotResult,      //没有数据
    TyLoadingStatus_Failure,    //加载失败
    TyLoadingStatus_NotLogin  //需要登录
};

NS_ASSUME_NONNULL_BEGIN

@interface EPRequestView : UIView

@property (nonatomic, strong) UIImageView *statusView;

@property (nonatomic, strong) UILabel *msgLabel;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, assign) TyLoadingStatus status;


@property (nonatomic, copy) void (^reloadBlock)(void);
@property (nonatomic, copy) void (^notResultBlock)(void);
@property (nonatomic, copy) void (^notLoginBlock)(void);


#pragma mark - 自定义图标文字

- (void)setFailureTitle:(NSString *)title Icon:(UIImage *)image;

- (void)setNotResultTitle:(NSString *)title Icon:(UIImage *)image;

- (void)setNotLoginTitle:(NSString *)title Icon:(UIImage *)image;


@end

NS_ASSUME_NONNULL_END
