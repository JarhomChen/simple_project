//
//  UIColor+EPAdd.m
//  EPProject
//
//  Created by Jarhom on 2019/4/29.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import "UIColor+EPAdd.h"

@implementation UIColor (EPAdd)

+ (UIColor *)ep_backgroundColor {
    return [UIColor colorWithHexString:@"#f5f5f5"];
}

+ (UIColor *)ep_blueColor {
    return [UIColor colorWithHexString:@"#3585FF"];
}
//大标题颜色  #333333
+ (UIColor *)ep_titleColor {
    return [UIColor colorWithHexString:@"#333333"];
}
//副标题颜色 #666666
+ (UIColor *)ep_subtitleColor {
    return [UIColor colorWithHexString:@"#666666"];
}
//描述颜色  #999999
+ (UIColor *)ep_descriptionColor {
    return [UIColor colorWithHexString:@"#999999"];
}

///主题颜色
+ (UIColor *)ep_themeColor {
    return [UIColor colorWithHexString:@"#3C8AFF"];
}


+ (UIColor *)ep_lineColor {
    return [UIColor colorWithHexString:@"#F4F5F6"];
}

+ (UIColor *)ep_disableColor {
    return [UIColor colorWithHexString:@"#F4F5F6"];
}
@end
