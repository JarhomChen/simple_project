//
//  YDWebViewController.m
//  SBFriends
//
//  Created by Jarhom on 2017/9/12.
//  Copyright © 2017年 厦门一品威客. All rights reserved.
//



#import "EPWebViewController.h"
#import <WebKit/WebKit.h>
#import "WKWebViewJavascriptBridge.h"


static void *SBWebBrowserContext = &SBWebBrowserContext;


@interface EPWebViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (strong, nonatomic) NSURL *URLToLaunchWithPermission;

@property (nonatomic, strong) WKWebViewJavascriptBridge *bridge;

@end

@implementation EPWebViewController

//- (instancetype)initWithHtmlPage:(TyHtmlPage)page {
//    self = [super init];
//    if (self) {
//        NSString *urlString = nil;
//        switch (page) {
//            default:
//                break;
//        }
//        if (!urlString) return nil;
//        self.url = [NSURL URLWithString:urlString];
//    }
//    return self;
//}

- (id)initWithUrlString:(NSString *)urlString{
    self = [super init];
    if (self) {
        self.url = [NSURL URLWithString:urlString];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
//    configuration.processPool = [[self class] shareProcessPool];
    
//    CGRect frame = self.view.bounds;
//    frame.origin.y = 20;
//    frame.size.height -= 20;
    
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    [self.webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.webView setNavigationDelegate:self];
    [self.webView setUIDelegate:self];
    [self.webView setMultipleTouchEnabled:YES];
    [self.webView setAutoresizesSubviews:YES];
    
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }

    self.webView.scrollView.bounces = NO;
    [self.view addSubview:self.webView];
    
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:SBWebBrowserContext];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    
    __weak __typeof(self) weakSelf = self;

    //register handle
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];

    [_bridge registerHandler:@"goBackward" handler:^(id data, WVJBResponseCallback responseCallback) {
        [weakSelf navBackAction];
    }];
    

    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
    [self.progressView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.progressView.frame.size.height)];
    
    //设置进度条颜色
    [self.progressView setTintColor:[UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000]];
    [self.view addSubview:self.progressView];
    [self loadURL:self.url];
    
    
    [self.view setReloadBlock:^{
        [weakSelf loadURL:weakSelf.url];
    }];
    
    
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView removeObserver:self forKeyPath:@"title"];
}


- (void)navBackAction {
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController || self.navigationController.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

//+ (WKProcessPool *)shareProcessPool {
//    static WKProcessPool *_shareProcessPool = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _shareProcessPool = [[WKProcessPool alloc] init];
//    });
//
//    return _shareProcessPool;
//}


#pragma mark - Public Interface
- (void)loadRequest:(NSURLRequest *)request {
    
    [self.webView loadRequest:request];
}

- (void)loadURL:(NSURL *)URL {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self loadRequest:request];
}

- (void)loadURLString:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}

- (void)loadwithNewPageURL:(NSURL *)URL {
    
//    NSString *urlStr = [URL.absoluteString stringByReplacingOccurrencesOfString:@"openNewPage=1" withString:@"openNewPage=0"];
    
//    [[SBRooterManager shareInstance] gotoYueDanHtmlPage:urlStr];
}

#pragma mark - WKNavigationDelegate


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
//    [YDUtil logCookies:@"didStartProvisionalNavigation:"];

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.view hideRequestView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DLog(@"%@---%@",NSStringFromCGRect(self.webView.scrollView.frame),NSStringFromCGSize(self.webView.scrollView.contentSize));
    });
    
    
    
    
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    [self.view requestWithStatus:TyLoadingStatus_Failure];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    
    NSURL *URL = navigationAction.request.URL;
    DLog(@"request:%@",URL.absoluteString);

    if ([self shouldOpenNewWebViewController:URL]) {
        [self loadwithNewPageURL:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    if(![self externalAppRequiredToOpenURL:URL]) {
        if(!navigationAction.targetFrame) {
            [self loadURL:URL];
            decisionHandler(WKNavigationActionPolicyCancel);
            return;
        }
        [self callback_webViewShouldStartLoadWithRequest:navigationAction.request navigationType:navigationAction.navigationType];
        
    }
    else if([[UIApplication sharedApplication] canOpenURL:URL]) {
        [self launchExternalAppWithURL:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
    
}

-(BOOL)callback_webViewShouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(NSInteger)navigationType
{
    
    return YES;
}


#pragma mark - WKUIDelegate

//- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
//    if (!navigationAction.targetFrame.isMainFrame) {
//        [webView loadRequest:navigationAction.request];
//    }
//    return nil;
//}
#pragma mark - Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
        return;
    }
    
    if ([keyPath isEqualToString:@"title"] && object == self.webView) {
        self.title = self.webView.title;
    }
}

#pragma mark - External App Support

- (BOOL)externalAppRequiredToOpenURL:(NSURL *)URL {
    
    
//    if ([URL.absoluteString hasPrefix:@"weixin://"]) {
//        
//        return YES;
//    }
    
    return !URL;
}


- (BOOL)shouldOpenNewWebViewController:(NSURL *)URL {

    if ([URL.absoluteString rangeOfString:@"openNewPage=1"].length>0) {
        return YES;
    }
    
    return NO;
}

- (void)launchExternalAppWithURL:(NSURL *)URL {
    self.URLToLaunchWithPermission = URL;
    
    __weak __typeof(self) weakSelf = self;
    [UIAlertController showAlertInViewController:self withTitle:@"提示" message:@"链接跳转即将离开app，是否继续？" cancelButtonTitle:@"取消" destructiveButtonTitle:@"继续" otherButtonTitles:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:weakSelf.URLToLaunchWithPermission];
            
        }
    }];
    
}




@end
