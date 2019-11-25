//
//  WKWebView+delegetePop.m
//  PDFReader
//
//  Created by 王放歌 on 2018/11/28.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import "WKWebView+delegetePop.h"
#import "NSString+URL.h"
#import "Url.h"
#import "FGNetConfig.h"
#import "ConfigManager.h"

@implementation WKWebView (delegetePop)

- (void)gotoDelegateWeb:(NSString*)url {    
    //处理302跳转的URL
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    url = [url URLEncodedString];
//    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "]];
    NSString *delegeteUrl = [NSString stringWithFormat:@"%@%@?return_url=%@",BaseUrl,DelegateWeb,url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:delegeteUrl]];
    NSDictionary *headerDic = [FGNetConfig getHeadDicAppContext:DelegateWeb];
    // 开始设置请求头
    for (NSString *key in headerDic.allKeys) {
        if (key.length) {
            [request setValue:headerDic[key] forHTTPHeaderField:key];
        }
    }
    
    UserInfo *user = [[ConfigManager sharedInstance] getCurrentUser];
    if (user.currentBookSchool != nil) {
        [request setValue:user.currentBookSchool.schoolId forHTTPHeaderField:@"SCHOOL_ID"];
    }
    if (user.currentBookClass != nil) {
        [request setValue:user.currentBookClass.firstObject.classId forHTTPHeaderField:@"CLASS_ID"];
    }
    
    [self loadRequest:request];
}

- (void)gotoUrl:(NSString*)url {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [self loadRequest:request];
}


- (void)openFile:(NSString *)filePath {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];

    [self loadRequest:request];
    
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
//    [self loadData:data MIMEType:@"xlsx" characterEncodingName:@"UTF-8" baseURL:[NSURL fileURLWithPath:filePath]];
}

@end
