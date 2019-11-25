//
//  NSObject+UIFram.m
//  PDFReader
//
//  Created by 王放歌 on 2019/3/26.
//  Copyright © 2019年 com.chineseall.www. All rights reserved.
//

#import "NSObject+UIFram.h"

@implementation NSObject (UIFram)

- (CGFloat)uiWidthBy:(CGFloat)width {
    return [[UIScreen mainScreen] widthByScale:(width / 2048.0f)];
}

- (CGFloat)uiHeightBy:(CGFloat)height {
    return [[UIScreen mainScreen] heightByScale:(height / 1536.0f)];
}
@end
