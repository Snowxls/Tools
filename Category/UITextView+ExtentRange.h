//
//  UITextView+ExtentRange.h
//  PDFReader
//
//  Created by 酌晨茗 on 2018/11/28.
//  Copyright © 2018 com.chineseall.www. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (ExtentRange)

/**
 获取光标位置
 */
- (NSRange)selectedRange;

/**
 设置光标的位置
 */
- (void)setSelectedRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
