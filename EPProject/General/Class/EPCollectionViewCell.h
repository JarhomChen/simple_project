//
//  LBCollectionViewCell.h
//  LBGoods
//
//  Created by Jarhom on 2017/10/10.
//  Copyright © 2017年 GMQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EPCollectionViewCell;

@protocol EPCollectionViewCellDelegate<NSObject>

@optional
- (void)collectionViewCell:(EPCollectionViewCell *)cell clickElement:(UIView *)element;

@end




@interface EPCollectionViewCell : UICollectionViewCell

+ (CGSize)itemSize;

@property (weak, nonatomic) id <EPCollectionViewCellDelegate>delegate;


@property (nonatomic, weak) IBOutlet UILabel *titlelab;

@property (nonatomic, weak) IBOutlet UILabel *subTitlelab;

@property (nonatomic, weak) IBOutlet UILabel *thirdTitlelab;

@property (nonatomic, weak) IBOutlet UIImageView *imgView;

@property (nonatomic, weak) IBOutlet UIButton *btn;


@end
