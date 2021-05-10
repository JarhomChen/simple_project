//
//  EPHomeViewController.m
//  EPProject
//
//  Created by Jarhom on 2019/2/27.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "EPHomeViewController.h"
#import "JHImagePickerManager.h"

@interface EPHomeViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EPHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    
    __weak typeof(self) weakSelf = self;
    [self.tableView setReloadBlock:^{
        [weakSelf loadData];
    }];
    
    [self.tableView setNotResultBlock:^{
        [weakSelf loadData];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[JHImagePickerManager shareInstance] pickImageWithMaxCount:1 shouldCropWhenPickOne:YES complete:^(NSArray *images) {
            
        }];
    });
}

- (void)loadData {
    [self.tableView requestWithStatus:TyLoadingStatus_Loading];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView requestWithStatus:TyLoadingStatus_NotLogin];
        [self.tableView requestWithStatus:TyLoadingStatus_NotResult];
//        [self.tableView requestWithStatus:TyLoadingStatus_Failure];
//        [self.tableView hideRequestView];
    });
    
    
    [EPClient checkAppVersionInfoWithRetryTime:3 shouldAlert:YES complete:^(BOOL hasNew, NSString *url, NSString *version) {
        
    }];
    
}
- (IBAction)loginhandle:(id)sender {
    [[EPRooterManager shareInstance] gotoLoginViewController];
}

#pragma mark -  UITableViewDataSource<NSObject>



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
