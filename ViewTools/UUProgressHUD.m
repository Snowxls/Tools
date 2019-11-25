//
//  UUProgressHUD.m
//  PDFReader
//
//  Created by 酌晨茗 on 2018/8/14.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import "UUProgressHUD.h"
#import "MBProgressHUD.h"

@implementation UUProgressHUD

static MBProgressHUD *hud = nil;
+ (void)showHUDInView:(UIView *)view title:(NSString *)title {
    hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = title;
}

+ (void)hideHUDWithAnimated:(BOOL)animated {
    [hud hideAnimated:animated];
}

@end
