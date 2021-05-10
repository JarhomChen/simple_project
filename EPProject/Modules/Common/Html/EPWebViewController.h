//
//  YDWebViewController.h
//  SBFriends
//
//  Created by Jarhom on 2017/9/12.
//  Copyright © 2017年 厦门一品威客. All rights reserved.
//

#import "EPViewController.h"


@interface EPWebViewController : EPViewController

@property (strong, nonatomic) NSURL *url;

//- (instancetype)initWithHtmlPage:(TyHtmlPage)page;

- (id)initWithUrlString:(NSString *)urlString;

- (void)loadURLString:(NSString *)URLString;


@end
