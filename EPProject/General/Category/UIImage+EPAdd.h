//
//  UIImage+EPAdd.h
//  EPProject
//
//  Created by Jarhom on 2019/4/23.
//  Copyright © 2019 Jarhom. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    
    GradientTypeTopToBottom = 0,//从上到小
    
    GradientTypeLeftToRight = 1,//从左到右
    
    GradientTypeUpleftToLowright = 2,//左上到右下
    
    GradientTypeUprightToLowleft = 3,//右上到左下
    
};

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (EPAdd)

+ (UIImage *)ep_defaultAvatar;
+ (UIImage *)ep_defaultImage;



#pragma mark - 常用方法

/**
 根据颜色生成图片
 */
- (UIImage *)ep_imageWithColor:(UIColor *)color;

/**
 * 图片旋转
 */
- (UIImage *)rotateWithOrientation:(UIImageOrientation)orientation;



/**
 创建渐变色图片
 */
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;



/**
 生成二维码
 */
+ (UIImage *)createQrCodeWithString:(NSString *)string width:(CGFloat)width;

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size;


/**
 *  打水印
 *
 *  @param backgroundImage   背景图片
 *  @param markNameFilePath 右下角的水印图片
 */
+ (instancetype)waterMarkWithImageName:(UIImage *)backgroundImage andMarkImageName:(NSString *)markNameFilePath;



@end

NS_ASSUME_NONNULL_END
