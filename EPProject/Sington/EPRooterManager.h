//
//  EPRooterManager.h
//  EPProject
//
//  Created by Jarhom on 2019/2/13.
//  Copyright © 2019 Jarhom. All rights reserved.
//  模块间跳转专用

#import <Foundation/Foundation.h>


@interface EPRooterManager : NSObject

+ (instancetype)shareInstance;

//启动初始化
- (void)initialWindowWhenDidFinishLaunching;
//跳转到首页
- (void)gotoHomePage;
//登录页面
- (void)gotoLoginViewController;

#pragma mark - HTML
- (void)gotoHtmlPageWithUrl:(NSString *)urlString;

#pragma mark - present
- (void)presentViewController:(UIViewController *)vc animated:(BOOL)flag;
- (void)dissmissViewControllerWithAnimated:(BOOL)flag;

//public
- (UIViewController *)getViewControllerWithStoryBoardName:(NSString *)storyBoardName
                                             storyBoardId:(NSString *)storyBoardId;

@end
