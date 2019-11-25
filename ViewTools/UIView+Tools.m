//
//  UIView+Tools.m
//  Questionnaire
//
//  Created by Zhuochenming on 16/7/11.
//  Copyright © 2016年 Zhuochenming. All rights reserved.
//

#import "UIView+Tools.h"

@implementation UIView (Tools)

- (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

- (CGFloat)leftOffset {
    return 15;
}

- (CGFloat)rightOffset {
    return -15;
}

- (CGFloat)topOffset
{
    return 10;
}

- (CGFloat)left {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)top {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)rightMargin {
    return CGRectGetWidth(self.superview.frame) - CGRectGetMaxX(self.frame);
}

- (CGFloat)bottomMargin {
    return CGRectGetHeight(self.superview.frame) - CGRectGetMaxY(self.frame);
}

- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

- (CGFloat)centerX {
    return self.center.x;
}

- (CGFloat)centerY {
    return self.center.y;
}

@end

@implementation UIView (Colors)

- (UIColor *)bacColor {
    return [UIColor colorWithRed:245 / 255.0 green:250 / 255.0 blue:254 / 255.0 alpha:1.0];
}

- (UIColor *)blackColor {
    return [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0];
}

- (UIColor *)grayColor {
    return [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.0];
}

- (UIColor *)blueColor {
    return [UIColor colorWithRed:75 / 255.0 green:137 / 255.0 blue:220 / 255.0 alpha:1.0];
}

- (UIColor *)redColor {
    return [UIColor colorWithRed:252 / 255.0 green:108 / 255.0 blue:108 / 255.0 alpha:1.0];
}

- (UIColor *)greenColor {
    return [UIColor colorWithRed:95 / 255.0 green:241 / 255.0 blue:96 / 255.0 alpha:1.0];
}

- (UIColor *)bigBorderColor {
    return [UIColor colorWithRed:172 / 255.0 green:208 / 255.0 blue:255 / 255.0 alpha:1.0];
}

- (UIColor *)smallBorderColor {
    return [UIColor colorWithRed:75 / 255.0 green:137 / 255.0 blue:220 / 255.0 alpha:1.0];
}

- (UIColor *)tableViewBGColor
{
   return [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1.0];
}

- (UIColor *)tableViewLineColor
{
    return [UIColor colorWithRed:224 / 255.0 green:224 / 255.0 blue:224 / 255.0 alpha:1.0];
}

@end

@implementation UIView (FontSize)

- (UIFont *)bigFont {
    if ([UIScreen mainScreen].bounds.size.height < 350) {
        return [UIFont systemFontOfSize:13];
    }
    
    return [UIFont systemFontOfSize:15];
}

- (UIFont *)smallFont {
    if ([UIScreen mainScreen].bounds.size.height < 350) {
        return [UIFont systemFontOfSize:11];
    }
    return [UIFont systemFontOfSize:13];
}

- (UIFont *)tinyFont {
    if ([UIScreen mainScreen].bounds.size.height < 350) {
        return [UIFont systemFontOfSize:9];
    }
    return [UIFont systemFontOfSize:11];
}

- (UIFont *)MainFontWithSize:(CGFloat)size {
//    return [UIFont fontWithName:@"SourceHanSansCN-Medium" size:size];
    return [UIFont systemFontOfSize:size];
}

- (UIFont *)BoldMainFontWithSize:(CGFloat)size {
//    return [UIFont fontWithName:@"SourceHanSansCN-Heavy" size:size];
    return [UIFont boldSystemFontOfSize:size];
}

@end

