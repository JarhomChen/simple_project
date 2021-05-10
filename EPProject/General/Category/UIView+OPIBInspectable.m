//
//  UIView+HDIBInspectable.m
//  YQW
//
//  Created by suziqiang on 16/7/15.
//  Copyright (c) 2016年 YQW. All rights reserved.
//

#import "UIView+OPIBInspectable.h"

#define EP_SEPARATION_LINE_COLOR [UIColor colorWithHexString:@"0xf4f4f4"]
#define ScreenWith [UIScreen mainScreen].bounds.size.width

@implementation UIView (OPIBInspectable)

#pragma mark - setCornerRadius/borderWidth/borderColor
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}


- (BOOL)bottomLine {
    return [objc_getAssociatedObject(self, @selector(bottomLine)) boolValue];
}

- (BOOL)topLine {
    return [objc_getAssociatedObject(self, @selector(topLine)) boolValue];
}

- (CGFloat)bottomX {
    return [objc_getAssociatedObject(self, @selector(bottomX)) floatValue];
}


- (void)setBottomLine:(BOOL)bottomLine {
    objc_setAssociatedObject(self, @selector(bottomLine), @(bottomLine),OBJC_ASSOCIATION_ASSIGN);
    if (bottomLine) {
        CALayer *line = [CALayer layer];
        
        [line setBackgroundColor:EP_SEPARATION_LINE_COLOR.CGColor];
        //[line setDk_backgroundColorPicker:DKColorPickerWithKey(@"LINE")];
        line.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
        [self.layer addSublayer:line];
    }
}


- (void)setTopLine:(BOOL)topLine {
    
    objc_setAssociatedObject(self, @selector(topLine), @(topLine), OBJC_ASSOCIATION_ASSIGN);
    if (topLine) {
        CALayer *line = [CALayer layer];
        [line setBackgroundColor:EP_SEPARATION_LINE_COLOR.CGColor];
        //[line setDk_backgroundColorPicker:DKColorPickerWithKey(@"LINE")];
        line.frame = CGRectMake(0, 0, ScreenWith, 0.5);
        [self.layer addSublayer:line];
    }
}

- (void)setBottomX:(CGFloat)bottomX {
    objc_setAssociatedObject(self, @selector(bottomX), @(bottomX), OBJC_ASSOCIATION_ASSIGN);
    if (bottomX >0.01) {
        CALayer *line = [CALayer layer];
        [line setBackgroundColor:EP_SEPARATION_LINE_COLOR.CGColor];
        //[line setDk_backgroundColorPicker:DKColorPickerWithKey(@"LINE")];
        line.frame = CGRectMake(bottomX, self.frame.size.height - 0.5, self.frame.size.width - bottomX, 0.5);
        [self.layer addSublayer:line];
    }
}


@end
