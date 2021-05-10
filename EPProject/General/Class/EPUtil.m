//
//  JPUtil.m
//  XXGoods
//
//  Created by Jarhom on 2017/10/10.
//  Copyright © 2017年 GMQ. All rights reserved.
//

#import "EPUtil.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "sys/utsname.h"

@implementation EPUtil



//int->     xx.00M
+ (NSString *)diskSizeFormatWithInt64:(int64_t)size {
    
    
    CGFloat item = 1000.0;
    
    if(size >= item*item*item)//以G为单位
    {
        return [NSString stringWithFormat:@"%.1fG",(CGFloat)size/item/item/item];
    }
    else if(size >=item*item && size < item*item*item)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%.1fM",(CGFloat)size/item/item];
    }
    else if(size>=item&&size<item*item) //不到1M,但是超过了1KB，则转化成KB单位
    {
        CGFloat showFlo = (CGFloat)size/item;
        if (showFlo < 0.1)
        {
            return [NSString stringWithFormat:@"0K"];
        }
        return [NSString stringWithFormat:@"%.1fK",(CGFloat)size/item];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        //        if (size == 0)
        //        {
        return [NSString stringWithFormat:@"0K"];
        //        }
        //        return [NSString stringWithFormat:@"%.1fB",(CGFloat)size];
    }
    
}



//取from到to之间的随机数
+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}



#pragma mark - UI

+ (BOOL)isIphoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        // judgment by height when in simulators
        
        BOOL isIphoneX = (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) ||
                          CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)));
        /// iphoneXR & XsMax
        BOOL isIphoneXR = (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 896)) ||
                           CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(896, 414)));
        
        return (isIphoneX || isIphoneXR);
    }
    BOOL isIPhoneX =
    [platform isEqualToString:@"iPhone10,3"] ||
    [platform isEqualToString:@"iPhone10,6"] ||
    [platform isEqualToString:@"iPhone11,2"] ||
    [platform isEqualToString:@"iPhone11,4"] ||
    [platform isEqualToString:@"iPhone11,6"] ||
    [platform isEqualToString:@"iPhone11,8"];
    return isIPhoneX;
}

+ (CGFloat)navBarBottom {
    return [self isIphoneX] ? 88 : 64;
}
+ (CGFloat)tabBarHeight {
    return [self isIphoneX] ? 83 : 49;
}
+ (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}
+ (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}



@end
