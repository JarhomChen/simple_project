//
//  UIColor+EPAdd.h
//  EPProject
//
//  Created by Jarhom on 2019/4/29.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (EPAdd)

+ (UIColor *)ep_backgroundColor;


+ (UIColor *)ep_blueColor;
//大标题颜色  #333333
+ (UIColor *)ep_titleColor;
///副标题颜色 #666666
+ (UIColor *)ep_subtitleColor;
///描述颜色  #999999
+ (UIColor *)ep_descriptionColor;

///主题颜色  
+ (UIColor *)ep_themeColor;

///分割线颜色  #F4F5F6
+ (UIColor *)ep_lineColor;
///按钮disable状态颜色
+ (UIColor *)ep_disableColor;

@end

NS_ASSUME_NONNULL_END
