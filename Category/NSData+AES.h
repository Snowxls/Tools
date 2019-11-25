//
//  NSData+AES.h
//  PDFReader
//
//  Created by Snow WarLock on 2018/11/21.
//  Copyright © 2018 com.chineseall.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

/**
 AES加密
 
 @param key 密钥
 @param iv 偏移量
 */
- (NSData *)AES128EncryptWithKey:(NSString *)key iv:(NSString *)iv;

/**
 AES解密
 
 @param key 密钥
 @param iv 偏移量
 */
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv;



@end
