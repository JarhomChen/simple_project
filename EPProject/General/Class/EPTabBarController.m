//
//  EPTabBarController.m
//  EPProject
//
//  Created by Jarhom on 2019/2/23.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "EPTabBarController.h"

@interface EPTabBarController ()

@end

@implementation EPTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - status Bar

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self.selectedViewController preferredStatusBarStyle];
}
- (BOOL)prefersStatusBarHidden {
    return [self.selectedViewController prefersStatusBarHidden];
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
