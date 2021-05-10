//
//  AJWaveRefreshAutoStateFooter.m
//  AJWaveRefresh
//
//  Created by AlienJunX on 15/10/16.
//  Copyright (c) 2015 AlienJunX
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import "AJWaveRefreshAutoStateFooter.h"
#import "AJWaveRefreshAnimation.h"

@interface AJWaveRefreshAutoStateFooter()
@property (weak, nonatomic) AJWaveRefreshAnimation *logoView;
@end

@implementation AJWaveRefreshAutoStateFooter

- (AJWaveRefreshAnimation *)logoView {
    if (!_logoView) {
        AJWaveRefreshAnimation *logoView = [[AJWaveRefreshAnimation alloc] initWithFrame:CGRectMake(100, 100, 75, 20)
                                                                       grayImage:[UIImage imageNamed:@"logo_light_gray"]
                                                                        redImage:[UIImage imageNamed:@"logo_gray"]];
        [self addSubview:_logoView = logoView];
    }
    return _logoView;
}

#pragma makr - 重写父类的方法
- (void)prepare {
    [super prepare];
    
    self.mj_h = 60;
    self.stateLabel.textColor = [UIColor colorWithHexString:@"#999999"];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    CGFloat centerY = self.mj_h * 0.5;
    self.stateLabel.frame = CGRectMake(0, 0, self.frame.size.width, 30);
    self.logoView.center = CGPointMake(self.mj_w * 0.5, centerY - 8);
    
    if (self.state == MJRefreshStateIdle ||  self.state == MJRefreshStateRefreshing) {
        self.stateLabel.center = CGPointMake(self.mj_w * 0.5, centerY + 15);
    } else {
        self.stateLabel.center = CGPointMake(self.mj_w * 0.5, centerY*0.5);
    }
    
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        [self.logoView stopAnimating];
        [self setFooterHidden:YES];
        
    } else if (state == MJRefreshStateRefreshing) {
        [self.logoView startAnimating];
        [self setFooterHidden:NO];
        
    } else if (state == MJRefreshStateNoMoreData) {
        [self.logoView stopAnimating];
        self.logoView.hidden = YES;

        if (self.scrollView.contentSize.height<self.scrollView.height+100) {
            self.stateLabel.hidden = YES;
        }
        
    }
}

- (void)setFooterHidden:(BOOL)hidden {
    self.logoView.hidden = hidden;
    self.stateLabel.hidden = hidden;
}

@end
