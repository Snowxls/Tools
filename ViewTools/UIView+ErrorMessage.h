//
//  UIView+Empty.h
//  PDFReader
//
//  Created by 酌晨茗 on 2018/9/12.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ErrorMessage)

/**
 展示在某个View上的文本提示，如果当前View有提示，会先移除

 @param message 文本信息
 @param edge 边距
 */
- (void)showErrorMessage:(NSString *)message edge:(UIEdgeInsets)edge;


/**
 更新文本信息

 @param message 信息
 */
- (void)changeErrorMessage:(NSString *)message;

/**
 设置背景色
 
 @param color 颜色
 */
- (void)setErrorMessageBackgroundColor:(UIColor*)color;

/**
 隐藏提示框
 */
- (void)dismissErrorMessage;

@end
