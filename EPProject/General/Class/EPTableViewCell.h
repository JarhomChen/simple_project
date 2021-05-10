//
//  EPTableViewCell.h
//  XXGoods
//
//  Created by Jarhom on 2017/10/10.
//  Copyright © 2017年 GMQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EPTableViewCell;

@protocol EPTableViewCellDelegate<NSObject>

- (void)tableViewCell:(EPTableViewCell *)cell clickElement:(UIView *)element;

@end

@interface EPTableViewCell : UITableViewCell

//获取重用标识符
+(NSString *)getCellWithReuseIdentifier;

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;

@property (weak, nonatomic) IBOutlet UILabel *thirdTitleLab;

@property (weak, nonatomic) IBOutlet UIImageView *selectImageV;

@property (nonatomic, weak) IBOutlet UIButton *btn;


@property (weak, nonatomic) id<EPTableViewCellDelegate>delegate;

@end
