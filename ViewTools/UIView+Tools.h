//
//  UIView+Tools.h
//  Questionnaire
//
//  Created by Zhuochenming on 16/7/11.
//  Copyright © 2016年 Zhuochenming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tools)

- (CGFloat)screenWidth;

- (CGFloat)screenHeight;

- (CGFloat)leftOffset;

- (CGFloat)rightOffset;

- (CGFloat)topOffset;


- (CGFloat)left;

- (CGFloat)right;

- (CGFloat)top;

- (CGFloat)bottom;

- (CGFloat)rightMargin;

- (CGFloat)bottomMargin;

- (CGFloat)width;

- (CGFloat)height;

- (CGFloat)centerX;

- (CGFloat)centerY;

@end

@interface UIView (Colors)

- (UIColor *)bacColor;

- (UIColor *)blackColor;

- (UIColor *)grayColor;

- (UIColor *)blueColor;

- (UIColor *)redColor;

- (UIColor *)greenColor;

- (UIColor *)bigBorderColor;

- (UIColor *)smallBorderColor;

- (UIColor *)tableViewBGColor;

- (UIColor *)tableViewLineColor;

@end

@interface UIView (FontSize)

- (UIFont *)bigFont;

- (UIFont *)smallFont;

- (UIFont *)tinyFont;

- (UIFont *)MainFontWithSize:(CGFloat)size;
- (UIFont *)BoldMainFontWithSize:(CGFloat)size;

@end

