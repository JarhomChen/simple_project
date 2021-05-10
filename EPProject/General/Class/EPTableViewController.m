//
//  EPTableViewController.m
//  XXConnect
//
//  Created by jarhom on 2018/1/12.
//  Copyright © 2018年 GMQ. All rights reserved.
//

#import "EPTableViewController.h"

@interface EPTableViewController ()

@end

@implementation EPTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)){
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.contentInset = UIEdgeInsetsMake([EPUtil navBarBottom], 0, 0, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - status bar

- (UIStatusBarStyle)preferredStatusBarStyle {
        return UIStatusBarStyleDefault;
//    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
