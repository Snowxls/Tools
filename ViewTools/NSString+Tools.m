//
//  NSString+Tools.m
//  PDFReader
//
//  Created by Snow WarLock on 2018/3/21.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)

- (CGFloat)getHeightWithWidth:(CGFloat)width font:(UIFont *)font {
    if (self.length == 0) {
        return 0;
    }
    return [self boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : font} context:nil].size.height;
}

- (BOOL)isHaveEmojiString {
    __block BOOL containsEmoji = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])        options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f9c0) {
                    containsEmoji = YES;
                }
            }
        }
        else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3 || ls == 0xfe0f || ls == 0xd83c) {
                containsEmoji = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                containsEmoji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                containsEmoji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                containsEmoji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                containsEmoji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                containsEmoji = YES;
            }
        }
        
        if (containsEmoji) {
            *stop = YES;
        }
    }];
    
    return containsEmoji;
}

- (BOOL)isEmojiString {
    if (self.length == 0) {
        return NO;
    }
    
    __block BOOL isPureEmojiString = YES;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        BOOL containsEmoji = NO;
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f9c0) {
                    containsEmoji = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3 || ls == 0xfe0f || ls == 0xd83c) {
                containsEmoji = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff) {
                containsEmoji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                containsEmoji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                containsEmoji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                containsEmoji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                containsEmoji = YES;
            }
        }
        
        if (!containsEmoji) {
            isPureEmojiString = NO;
            *stop = YES;
        }
    }];
    
    return isPureEmojiString;
}

- (NSString *)removeEmojiString {
    return  [self stringByReplaceingEmojiWithString:@""];
}

- (NSString *)stringByReplaceingEmojiWithString:(NSString *)string {
    NSMutableString * __block buffer = [NSMutableString stringWithCapacity:[self length]];
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock: ^(NSString * substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
        [buffer appendString:([substring isEmojiString]) ? (string? : @"") : substring];
    }];
    return buffer;
}

@end
