//
//  NSString+Tools.h
//  PDFReader
//
//  Created by Snow WarLock on 2018/3/21.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Tools)


/**
 获取文本的最小包含k高度

 @param width 文本的最大宽度
 @param font 字体
 @return 高度
 */
- (CGFloat)getHeightWithWidth:(CGFloat)width font:(UIFont *)font;

/**
 字符串中是否包含emoji字符串
 @return YES为包含emoji
 */
- (BOOL)isHaveEmojiString;

/**
 是否为纯emoji字符串
 @return YES为纯emoji字符串
 */
- (BOOL)isEmojiString;


/**
 字符串去掉emoji
 @return 字符串
 */
- (NSString *)removeEmojiString;


@end
