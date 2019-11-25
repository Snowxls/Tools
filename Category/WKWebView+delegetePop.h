//
//  WKWebView+delegetePop.h
//  PDFReader
//
//  Created by 王放歌 on 2018/11/28.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import <WebKit/WebKit.h>


@interface WKWebView (delegetePop)

/**
 302跳转头的设置

 @param url 跳转前的url
 */
- (void)gotoDelegateWeb:(NSString*)url;

- (void)gotoUrl:(NSString *)url;

- (void)openFile:(NSString *)filePath;

@end
