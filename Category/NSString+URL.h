//
//  NSString+URL.h
//  PDFReader
//
//  Created by Snow WarLock on 2018/11/23.
//  Copyright © 2018 com.chineseall.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

/**
 *  URLEncode
 */
- (NSString *)URLEncodedString;

/**
 *  URLDecode
 */
-(NSString *)URLDecodedString;

@end

