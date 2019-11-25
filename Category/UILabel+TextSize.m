//
//  UILabel+TextSize.m
//  PDFReader
//
//  Created by Snow WarLock on 2019/2/12.
//  Copyright © 2019 com.chineseall.www. All rights reserved.
//

#import "UILabel+TextSize.h"

@implementation UILabel (TextSize)

- (CGSize)fixSingleTextSize {
    CGSize size = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName,nil]];
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    self.frame = CGRectMake(x, y, size.width, size.height);
    return size;
}

- (CGSize)fixMutableTextSize {
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    self.frame = CGRectMake(x, y, size.width, size.height);
    return size;
}

@end
