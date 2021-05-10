//
//  EPTabBarController.h
//  JPStudy
//
//  Created by 曾惠强 on 2018/6/22.
//  Copyright © 2018年 厦门一品威客集团. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPTabBarController.h"

@interface EPTabBarCTRL:EPTabBarController

//账号被踢，重置所有子控制器到首页，默认选中发现主页
-(void)resetViewControllers;

@end
