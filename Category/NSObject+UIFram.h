//
//  NSObject+UIFram.h
//  PDFReader
//
//  Created by 王放歌 on 2019/3/26.
//  Copyright © 2019年 com.chineseall.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (UIFram)

/**
 配率比获取宽
 */
- (CGFloat)uiWidthBy:(CGFloat)width;

/**
 配率比获取高
 */
- (CGFloat)uiHeightBy:(CGFloat)height;

@end

