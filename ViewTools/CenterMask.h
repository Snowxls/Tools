//
//  CenterMask.h
//  PDFReader
//
//  Created by Snow WarLock on 2018/12/11.
//  Copyright © 2018 com.chineseall.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DQAlertView.h"

@interface CenterMask : NSObject

/**
 创建旋转图标
 */
+ (void)createActivityIndicator;

/**
 显示旋转图标
 */
+ (void)showActivityIndicator;

/**
 取消旋转图标
 */
+ (void)dissActivityIndicator;

/**
 设置旋转颜色
 @param color 填充色
 */
+ (void)setActivityIndicatorColor:(UIColor *)color;

/**
 在指定View上显示HUD
 @param autoRelease 是否自动隐藏 默认显示1秒
 */
+ (void)showHUDInView:(UIView *)view title:(NSString *)title autoRelease:(BOOL)autoRelease;

/**
 在Window上显示HUD
 @param autoRelease 是否自动隐藏 默认显示1秒
 */
+ (void)showHUDInWindowWithTitle:(NSString *)title autoRelease:(BOOL)autoRelease;

/**
 取消HUD
 */
+ (void)hideHUDWithAnimated:(BOOL)animated;

/**
 在Window上显示旋转图+HUD
 @param autoRelease 是否自动隐藏 默认显示1秒
 */
+ (void)showActivityIndicatorWithTitle:(NSString *)title autoRelease:(BOOL)autoRelease;

/**
 取消旋转图+HUD
 */
+ (void)dissActivityHUD;

@end

