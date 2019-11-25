//
//  UUProgressHUD.h
//  PDFReader
//
//  Created by 酌晨茗 on 2018/8/14.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUProgressHUD : UIView

+ (void)showHUDInView:(UIView *)view title:(NSString *)title;

+ (void)hideHUDWithAnimated:(BOOL)animated;

@end
