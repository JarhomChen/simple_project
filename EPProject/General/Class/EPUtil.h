//
//  JPUtil.h
//  XXGoods
//
//  Created by Jarhom on 2017/10/10.
//  Copyright © 2017年 GMQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EPUtil : NSObject

//int->     xx.00M
+ (NSString *)diskSizeFormatWithInt64:(int64_t)size;


//取from到to之间的随机数
+(int)getRandomNumber:(int)from to:(int)to;



#pragma mark - UI
+ (BOOL)isIphoneX;
+ (CGFloat)navBarBottom;
+ (CGFloat)tabBarHeight;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;


@end
