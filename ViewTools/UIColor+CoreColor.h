//
//  UIColor+CoreColor.h
//  ReadKid
//
//  Created by Snow WarLock on 2018/1/9.
//  Copyright © 2018年 Snow WarLock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CoreColor)

/**
 16进制ARGB转UIColor
 @param argb 16进制ARGB
 */
- (UIColor*) initWithARGB:(unsigned long)argb;

/**
 16进制RGB转UIColor
 @param rgb 16进制ARGB
 */
- (UIColor*) initWithRGB:(unsigned long)rgb;

/**
 16进制ARGB转UIColor
 @param argb 16进制ARGB
 */
+ (UIColor*) colorWithARGB:(unsigned long)argb;

/**
 16进制RGB转UIColor
 @param rgb 16进制ARGB
 */
+ (UIColor*) colorWithRGB:(unsigned long)rgb;

@end
