//
//  EPRequestView.m
//  EPProject
//
//  Created by Jarhom on 2019/2/27.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "EPRequestView.h"

#define kLoadingTitle      @"加载中"
#define kNoLoginTitle      @"您还未登录，点击登录"
#define kNoDataTitle       @"暂无相关数据"
#define kErrorTitle @"加载失败,点击重新加载"

@interface EPRequestView ()

@property (nonatomic, strong) NSString *failureTitle;
@property (nonatomic, strong) UIImage *failureImage;

@property (nonatomic, strong) NSString *notResultTitle;
@property (nonatomic, strong) UIImage *notResultImage;

@property (nonatomic, strong) NSString *notLogintTitle;
@property (nonatomic, strong) UIImage *notLoginImage;

@end

@implementation EPRequestView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (UIImageView *)statusView {
    if (!_statusView) {
        _statusView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame), 0, 0)];
        [self addSubview:_statusView];
    }
    return _statusView;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame), 0, 0 )];
        _msgLabel.font = [UIFont systemFontOfSize:16];
        _msgLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_msgLabel];
    }
    return _msgLabel;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.color = [UIColor colorWithHexString:@"#ff1371"];
        _indicatorView.hidesWhenStopped = YES;
        [self addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.statusView sizeToFit];
    self.statusView.centerX = CGRectGetWidth(self.frame)/2;
    self.statusView.centerY = CGRectGetHeight(self.frame)/2 - 30;
    
    self.indicatorView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2 - 30);
    
    CGFloat origin_Y = CGRectGetMaxY(self.statusView.frame);
    if (self.statusView.hidden) {
        origin_Y = CGRectGetMaxY(self.indicatorView.frame);
    }
    
    self.msgLabel.frame = CGRectMake(30, origin_Y+15, CGRectGetWidth(self.frame) - 60, 80);
    
}

#pragma mark - set

- (void)setStatus:(TyLoadingStatus)status {
    _status = status;
    self.indicatorView.hidden = status !=TyLoadingStatus_Loading;
    self.statusView.hidden = status == TyLoadingStatus_Loading;

    switch (status) {
        case TyLoadingStatus_Loading:
            [self.indicatorView startAnimating];
            self.msgLabel.text = kLoadingTitle;
            break;
        case TyLoadingStatus_NotResult:
            [self.indicatorView stopAnimating];
            self.statusView.image = self.notResultImage? :[UIImage imageNamed:@"Loading_NotResult"];
            self.msgLabel.text = self.notResultTitle? :kNoDataTitle;
            break;
        case TyLoadingStatus_Failure:
            [self.indicatorView stopAnimating];
            self.statusView.image = self.failureImage? :[UIImage imageNamed:@"Loading_Failure"];
            self.msgLabel.text = self.failureTitle? :kErrorTitle;
            break;
        case TyLoadingStatus_NotLogin:
            [self.indicatorView stopAnimating];
            self.statusView.image = self.notLoginImage? :[UIImage imageNamed:@"Loading_NotLogin"];
            self.msgLabel.text = self.notLogintTitle? :kNoLoginTitle;
            break;
        default:
            break;
    }
    
    [self layoutSubviews];
}

//自定义无数据
- (void)setNotResultTitle:(NSString *)title Icon:(UIImage *)image {
    self.notResultTitle = title;
    self.notResultImage = image;
}

//自定义加载失败
-(void)setFailureTitle:(NSString *)title Icon:(UIImage *)image {
    
    self.failureTitle = title;
    self.failureImage = image;
}

- (void)setNotLoginTitle:(NSString *)title Icon:(UIImage *)image {
    self.notLoginImage = image;
    self.notLogintTitle = title;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.status == TyLoadingStatus_NotResult) {
        if (self.notResultBlock) self.notResultBlock();
    } else if (self.status == TyLoadingStatus_Failure) {
        if (self.reloadBlock) self.reloadBlock();
    } else if (self.status == TyLoadingStatus_NotLogin) {
        if (self.notLoginBlock) self.notLoginBlock();
    }
}



@end
