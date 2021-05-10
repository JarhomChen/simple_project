//
//  EPCollectionView.m
//  planet
//
//  Created by 曾惠强 on 2018/9/17.
//  Copyright © 2018年 厦门一品威客集团. All rights reserved.
//

#import "EPCollectionView.h"

@implementation EPCollectionView

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize]))
    {
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize intrinsicContentSize = self.contentSize;
    
    return intrinsicContentSize;
}

@end
