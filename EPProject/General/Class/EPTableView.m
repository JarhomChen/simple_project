//
//  XXTableView.m
//  XXConnect
//
//  Created by 曾惠强 on 2018/3/16.
//  Copyright © 2018年 GMQ. All rights reserved.
//

#import "EPTableView.h"

@implementation EPTableView

/**
 同时识别多个手势
 
 @param gestureRecognizer gestureRecognizer description
 @param otherGestureRecognizer otherGestureRecognizer description
 @return return value description
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
