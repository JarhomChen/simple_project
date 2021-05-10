//
//  EPAuthCodeBtn.m
//  EPProject
//
//  Created by Jarhom on 2019/2/17.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "EPAuthCodeBtn.h"
#import "YYWeakProxy.h"

@interface EPAuthCodeBtn ()

//@property (nonatomic, strong) YY *<#object#>;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger count;

@end

@implementation EPAuthCodeBtn

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupButtonState:UIControlStateNormal];
    [self initTimer];

}


- (void)initTimer {
    YYWeakProxy *proxy = [YYWeakProxy proxyWithTarget:self];
    _timer = [NSTimer timerWithTimeInterval:1 target:proxy selector:@selector(countWorking) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    [_timer setFireDate:[NSDate distantFuture]];
    _count = 60;
}

- (BOOL)isCounting {
    return [self.timer.fireDate compare:[NSDate date]] == NSOrderedAscending;
}

- (void)countWorking {
    if (_count<=0) {
        [self stopCountTimer];
        return;
    }
    

    [self setTitle:[NSString stringWithFormat:@" %.2ld s ",_count] forState:UIControlStateDisabled];
    _count --;
    
}



- (void)startCountTimer {
    [self setupButtonState:UIControlStateDisabled];

    _count = 60;
    [_timer setFireDate:[NSDate distantPast]];
    [_timer fire];
    _hadSendAuthCode = YES;
}

- (void)stopCountTimer {
    [_timer setFireDate:[NSDate distantFuture]];
    [self setupButtonState:UIControlStateNormal];

}

- (void)setupButtonState:(UIControlState)state {

    self.enabled = state != UIControlStateDisabled;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
