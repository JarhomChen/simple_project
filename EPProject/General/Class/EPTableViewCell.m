//
//  EPTableViewCell.m
//
//  Created by Jarhom on 2017/10/10.
//  Copyright © 2017年 GMQ. All rights reserved.
//

#import "EPTableViewCell.h"

@implementation EPTableViewCell

+(NSString *)getCellWithReuseIdentifier
{
    return NSStringFromClass(self);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnHandle:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tableViewCell:clickElement:)]) {
        [self.delegate tableViewCell:self clickElement:sender];
    }
}

@end
