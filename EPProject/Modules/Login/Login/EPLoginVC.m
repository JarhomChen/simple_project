//
//  EPLoginVC.m
//  EPProject
//
//  Created by Jarhom on 2019/2/17.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "EPLoginVC.h"
#import "EPLoginInput.h"
#import "EPUserDefault.h"

@interface EPLoginVC ()<EPLoginInputDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextfield;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (nonatomic, strong) EPLoginInput *input;

@end

@implementation EPLoginVC

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.input = [[EPLoginInput alloc] init];
    self.input.delegate = self;
    self.input.phoneTextfield = self.phoneTextfield;
    self.input.pwdTextfield = self.pwdTextfield;
    self.input.commitBtn = self.commitBtn;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setLeftNavItem];

    
//    NSString *lastestUser = [EPUserDefault getLastestLoginUser];
//    if (lastestUser && [lastestUser validatePhoneNO]){
//        self.phoneTextfield.text = lastestUser;
//    }
}



#pragma mark - Private Method
- (void)setLeftNavItem {
    UIImage *backImage = [[UIImage imageNamed:@"Nav_Back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    UIBarButtonItem *itemleft = [[UIBarButtonItem alloc] initWithImage:backImage
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(popAction)];
    
    self.navigationItem.leftBarButtonItem = itemleft;
}

- (void)popAction {
    [[EPRooterManager shareInstance] dissmissViewControllerWithAnimated:YES];
}



#pragma mark - EPLoginInputDelegate <NSObject>
//提交
- (void)commitHandle:(UIButton *)btn {
    
    [self.view endEditing:YES];
    
    NSString *phone = [self.phoneTextfield.text stringByTrim];
    NSString *pwd = [self.pwdTextfield.text stringByTrim];
    
    if (![phone length]||![phone validatePhoneNO]) {
        [EPProgressHUD EP_showFailureInfo:@"请输入11位手机号码！"];
        return;
    }
    
    if (![pwd length]) {
        [EPProgressHUD EP_showFailureInfo:@"请输入登录密码！"];
        return;
    }
    [EPProgressHUD EP_showProgressHUD:nil];
    [[EPNetwork shareInstance] userLoginByAccount:phone password:pwd complete:^(NSInteger status, NSDictionary * _Nullable data, NSString * _Nullable msg) {
        if (status != 1) {
            [EPProgressHUD EP_showFailureInfo:msg];
            return ;
        }
        
        EPUserModel *user = [EPUserModel yy_modelWithJSON:data];
        user.mobile = phone;
        
        if (!user.uid) {
            [EPProgressHUD EP_showFailureInfo:@"数据出错"];
            return;
        }
        
        [EPClient loginWithUser:user];

        [EPProgressHUD EP_showSuccessInfo:@"登录成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //登录成功通知
            [[EPRooterManager shareInstance] dissmissViewControllerWithAnimated:YES];
        });

        
    }];
    

    
    
}

- (void)authCodeHandle:(EPAuthCodeBtn *)btn {
    
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
