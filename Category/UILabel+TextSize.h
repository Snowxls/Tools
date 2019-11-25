//
//  UILabel+TextSize.h
//  PDFReader
//
//  Created by Snow WarLock on 2019/2/12.
//  Copyright © 2019 com.chineseall.www. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (TextSize)

/**
 *  获取单行Size
 */
- (CGSize)fixSingleTextSize;

/**
 *  获取多行Size
 */
- (CGSize)fixMutableTextSize;

@end

NS_ASSUME_NONNULL_END
