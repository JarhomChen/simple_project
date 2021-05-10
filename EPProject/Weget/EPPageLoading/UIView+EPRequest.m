//
//  UIView+EPRequest.m
//  EPProject
//
//  Created by Jarhom on 2019/2/27.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "UIView+EPRequest.h"

static const char requestViewKey;

@implementation UIView (EPRequest)

- (void)requestWithStatus:(TyLoadingStatus)status {
    [self requestWithStatus:status awayTop:0 alpha:1];
    
}

- (void)requestWithStatus:(TyLoadingStatus)status alpha:(CGFloat)alpha {
    [self requestWithStatus:status awayTop:0 alpha:alpha];
}

- (void)requestWithStatus:(TyLoadingStatus)status awayTop:(NSInteger)height {
    [self requestWithStatus:status awayTop:height alpha:1];
}

- (void)requestWithStatus:(TyLoadingStatus)status awayTop:(NSInteger)height alpha:(CGFloat)alpha{
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    EPRequestView *view = [self requestView];
    view.status = status;
    view.frame = CGRectMake(0, height, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-height);
    view.alpha = alpha;
    
    view.hidden = NO;
    //    });
    
    
}

- (void)hideRequestView {
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    EPRequestView *view = [self requestView];
    view.status = TyLoadingStatus_None;
    view.hidden = YES;
    [view removeFromSuperview];
    //        objc_setAssociatedObject(self, &requestViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //    });
    
}

#pragma mark - set

- (void)setNotResultTitle:(NSString *)title Icon:(UIImage *)image {
    EPRequestView *view = [self requestView];
    [view setNotResultTitle:title Icon:image];
}


-(void)setFailureTitle:(NSString *)title Icon:(UIImage *)image {
    EPRequestView *view = [self requestView];
    [view setFailureTitle:title Icon:image];
}

- (void)setNotLoginTitle:(NSString *)title Icon:(UIImage *)image {
    EPRequestView *view = [self requestView];
    [view setNotLoginTitle:title Icon:image];
}

//设置重新加载block
- (void)setReloadBlock:(void(^)(void))reloadBlock {
    EPRequestView *view = [self requestView];
    view.reloadBlock = reloadBlock;
}

- (void)setNotLoginBlock:(void(^)(void))notLoginBlock {
    EPRequestView *view = [self requestView];
    view.notLoginBlock = notLoginBlock;
}

//设置没有数据跳转block
- (void)setNotResultBlock:(void(^)(void))notResultBlock {
    EPRequestView *view = [self requestView];
    view.notResultBlock = notResultBlock;
}

- (EPRequestView *)requestView {
    
    EPRequestView *view = objc_getAssociatedObject(self, &requestViewKey);
    if (!view) {
        view = [[EPRequestView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        view.backgroundColor = self.backgroundColor;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        view.hidden = YES;
        
        objc_setAssociatedObject(self, &requestViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    if (!view.superview) {
        if (([self isKindOfClass:[UIScrollView class]]) && self.subviews.count > 1) {
            [self insertSubview:view atIndex:0];
        }
        else {
            [self addSubview:view];
        }
    }
    
    
    [self bringSubviewToFront:view];
    
    
    return view;
    
    
}




@end
