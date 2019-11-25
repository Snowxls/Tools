//
//  CenterMask.m
//  PDFReader
//
//  Created by Snow WarLock on 2018/12/11.
//  Copyright © 2018 com.chineseall.www. All rights reserved.
//

#import "CenterMask.h"
#import "MBProgressHUD.h"

@interface CenterMask() {
    
}

@end

@implementation CenterMask

#pragma mark UIActivityIndicatorView

static UIActivityIndicatorView * activityIndicator = nil;
static UIView *mask = nil;

+ (void)createActivityIndicator {
    if (!activityIndicator) {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    }
    [[UIApplication sharedApplication].keyWindow addSubview:activityIndicator];
    //设置小菊花的frame
    activityIndicator.frame= CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    //设置小菊花颜色
    activityIndicator.color = [UIColor grayColor];
    //设置背景颜色
    activityIndicator.backgroundColor = [UIColor clearColor];
    //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
    activityIndicator.hidesWhenStopped = NO;
    [activityIndicator startAnimating];
}

+ (void)showActivityIndicator {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
        [self createActivityIndicator];
    }];
    
    
}

+ (void)dissActivityIndicator {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        [mask removeFromSuperview];
        mask = nil;
        activityIndicator = nil;
    }];
    
}

+ (void)setActivityIndicatorColor:(UIColor *)color {
    activityIndicator.color = color;
}

#pragma mark HUD

static MBProgressHUD *hud = nil;

+ (void)showHUDInView:(UIView *)view title:(NSString *)title autoRelease:(BOOL)autoRelease {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [hud hideAnimated:NO];
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = title;
        if (autoRelease) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        }
    }];
}

+ (void)showHUDInWindowWithTitle:(NSString *)title autoRelease:(BOOL)autoRelease {
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [hud hideAnimated:NO];
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = title;
        if (autoRelease) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
        }
    }];
}

+ (void)hideHUDWithAnimated:(BOOL)animated {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [hud hideAnimated:animated];
    }];
}

#pragma mark UIActivityIndicatorView+HUD
+ (void)showActivityIndicatorWithTitle:(NSString *)title autoRelease:(BOOL)autoRelease {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
        [self createActivityIndicator];
        
        [hud hideAnimated:NO];
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = title;
        if (autoRelease) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
                activityIndicator = nil;
                
                [hud hideAnimated:YES];
            });
        }
    }];
}

+ (void)dissActivityHUD {
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
    activityIndicator = nil;
    
    [hud hideAnimated:YES];
}

@end
