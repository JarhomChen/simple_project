//
//  EPCollectionViewCell.m
//
//  Created by Jarhom on 2017/10/10.
//  Copyright © 2017年 GMQ. All rights reserved.
//

#import "EPCollectionViewCell.h"

@implementation EPCollectionViewCell



+ (CGSize)itemSize {
    return CGSizeZero;
}


- (IBAction)btnHandle:(id)sender {
    if ([self.delegate respondsToSelector:@selector(collectionViewCell:clickElement:)]) {
        [self.delegate collectionViewCell:self clickElement:sender];
    }
}


@end
