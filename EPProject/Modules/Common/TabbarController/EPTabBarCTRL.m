//
//  EPTabBarController.m
//  JPStudy
//
//  Created by 曾惠强 on 2018/6/22.
//  Copyright © 2018年 厦门一品威客集团. All rights reserved.
//

#import "EPTabBarCTRL.h"

@interface EPTabBarCTRL ()<UITabBarControllerDelegate>

@end

@implementation EPTabBarCTRL

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupViewControllers];
    
    self.delegate = self;
    
    NSArray *titles = @[@"首页",@"头条新闻",@"客服中心",@"我的"];
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        
        obj.tabBarItem.image = [self createImageWithName:[NSString stringWithFormat:@"Tabbar_%lu",(unsigned long)idx]];
        obj.tabBarItem.selectedImage = [self createImageWithName:[NSString stringWithFormat:@"Tabbar_%lu_S",(unsigned long)idx]];
        
        obj.tabBarItem.title = titles[idx];
    }];
    
    //设置Tabbar字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#F23B3B"]} forState:UIControlStateSelected];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#ffffff"]]];
}

- (void)dealloc {
}

- (void)setupViewControllers{
    
    NSArray *storyBoards = @[@"EPHome",
                             @"EPNews",
                             @"EPService",
                             @"EPMine"];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    for (NSString *storyBoardName in storyBoards) {
        NSArray *sbNames = [storyBoardName componentsSeparatedByString:@"."];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:sbNames[0] bundle:nil];
        UIViewController *vc = nil;
        if (sbNames.count>1) {
            vc = [sb instantiateViewControllerWithIdentifier:sbNames[1]];
        } else {
            vc = [sb instantiateInitialViewController];
        }
        [viewControllers addObject:vc];
    }
    
    [self setViewControllers:viewControllers];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0) {

    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}

#pragma mark - private
- (UIImage *)createImageWithName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

#pragma mark -- public
-(void)resetViewControllers
{
    for (UINavigationController *vc in self.viewControllers) {
        if ([vc isKindOfClass:[UINavigationController class]]) {
            [vc popToRootViewControllerAnimated:NO];
        }
    }
    self.selectedIndex = 0;
}

#pragma mark - rotate
- (BOOL)shouldAutorotate {
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

@end
