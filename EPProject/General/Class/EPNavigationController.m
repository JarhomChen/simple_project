//
//  EPNavigationController.m
//  XXGoods
//
//  Created by Jarhom on 2017/10/10.
//  Copyright © 2017年 GMQ. All rights reserved.
//

#import "EPNavigationController.h"

@interface EPNavigationController ()

@end

@implementation EPNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    self.navigationBar.barStyle = UIBarStyleDefault;
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    DLog(@"[%@ dealloc]",self.class);
}

#pragma mark - status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}
- (BOOL)prefersStatusBarHidden {
    return [self.topViewController prefersStatusBarHidden];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}


@end
