//
//  EPRooterManager.m
//  EPProject
//
//  Created by Jarhom on 2019/2/13.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "EPRooterManager.h"
#import "AppDelegate.h"
#import "EPTabBarCTRL.h"
#import "EPNavigationController.h"
#import "EPWebViewController.h"



@interface EPRooterManager()

@property (nonatomic, strong) EPTabBarController *homeTabBarController;

@property (nonatomic, strong) EPNavigationController *loginNav;

@end

@implementation EPRooterManager


+ (instancetype)shareInstance {
    
    static EPRooterManager *_shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _shareInstance = [[EPRooterManager alloc] init];
    });
    
    return _shareInstance;
}

//启动初始化
- (void)initialWindowWhenDidFinishLaunching {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    delegate.window.backgroundColor = [UIColor blackColor];
    UIViewController *vc = [self getViewControllerWithStoryBoardName:@"Home" storyBoardId:nil];
    delegate.window.rootViewController = vc;
//    delegate.window.rootViewController = self.homeTabBarController;
    [delegate.window makeKeyAndVisible];
}

//跳转到首页
- (void)gotoHomePage {
    [[self currentNavigationController] popToRootViewControllerAnimated:NO];
    self.homeTabBarController.selectedIndex = 0;
}


//登录页面
- (void)gotoLoginViewController {
    //已经在登录页面
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *rootViewController = delegate.window.rootViewController;
    
    if (self.loginNav && rootViewController.presentedViewController == self.loginNav) {
        return;
    }
    
    self.loginNav = nil;
    
    EPNavigationController *vc = (EPNavigationController *)[self getViewControllerWithStoryBoardName:@"Login" storyBoardId:nil];
    
    [self presentViewController:vc animated:YES];
    self.loginNav = vc;
}


#pragma mark - HTML
- (void)gotoHtmlPageWithUrl:(NSString *)urlString {
    if (![urlString hasPrefix:@"http"]) {
        return;
    }
    EPWebViewController *vc = [[EPWebViewController alloc] initWithUrlString:urlString];
    vc.hidesBottomBarWhenPushed = YES;
    [[self currentNavigationController] pushViewController:vc animated:YES];
    
}



#pragma mark - get
- (EPTabBarCTRL *)homeTabBarController {
    if (!_homeTabBarController) {
        _homeTabBarController = [[EPTabBarCTRL alloc] init];
    }
    return _homeTabBarController;
}

#pragma mark - present
- (void)presentViewController:(UIViewController *)vc animated:(BOOL)flag {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *rootViewController = delegate.window.rootViewController;
    
    if (rootViewController.presentedViewController) {
        [rootViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
//        [JPAlertManager hide];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [rootViewController presentViewController:vc animated:flag completion:nil];
        });
        return;
        
    }
    
    [rootViewController presentViewController:vc animated:flag completion:nil];
    
}

- (void)dissmissViewControllerWithAnimated:(BOOL)flag {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *rootViewController = delegate.window.rootViewController;
    
    if (rootViewController.presentedViewController) {
        [rootViewController.presentedViewController dismissViewControllerAnimated:flag completion:nil];
        
        return;
        
    }
}

- (UIViewController *)getViewControllerWithStoryBoardName:(NSString *)storyBoardName
                                             storyBoardId:(NSString *)storyBoardId {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    
    UIViewController *vc = nil;
    if (storyBoardId) {
        vc = [sb instantiateViewControllerWithIdentifier:storyBoardId];
    } else {
        vc = [sb instantiateInitialViewController];
    }
    return vc;
}

#pragma mark - private
//获取当前NavigationController
- (EPNavigationController *)currentNavigationController{
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *rootViewController = delegate.window.rootViewController;
    
    
    if (rootViewController.presentedViewController && [rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        
        return (EPNavigationController *)rootViewController.presentedViewController;
    }
    
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        return (EPNavigationController *)rootViewController;
    }
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        
        EPNavigationController *nav = ((UITabBarController *)rootViewController).selectedViewController;
        return nav;
    }
    return nil;
    
}

@end
