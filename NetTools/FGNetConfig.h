//
//  FGNetConfig.h
//  PDFReader
//
//  Created by 王放歌 on 2018/11/21.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FGNetConfig : NSObject

#define GET_M     @"GET"
#define POST_M    @"POST"
#define PUT_M     @"PUT"
#define DELETE_M  @"DELETE"

//获取key专用
+ (void)getKeySuccessBlock:(void (^)(id responseObject, NSInteger statusCode))successBlock failureBlock:(void (^)( NSError *error,id responseObject, NSInteger statusCode))failureBlock;

/**
 获取headerDic

 @param context 接口api
 @return headerDic
 */
+ (NSDictionary *)getHeadDicAppContext:(NSString *)context;

/**
 通用数据请求
 
 @param method 数据请求方式
 @param urlString URL
 @param api 请求API
 @param bodyData 请求体
 @param parmertes 参数
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (NSURLSessionDataTask *)jsonWithrequestWithMethod:(NSString *)method Url:(NSString *)urlString Api:(NSString *)api bodyData:(NSData *)bodyData theParmeters:(NSDictionary *)parmertes uploadProgress:(void (^)(double uploadProgress)) uploadProgressBlock downloadProgress:(void (^)(double downloadProgress)) downloadProgressBlock successBlock:(void (^)(id responseObject, NSInteger statusCode))successBlock failureBlock:(void (^)( NSError *error,id responseObject, NSInteger statusCode))failureBlock;
/**
 get请求
 
 @param urlString 网站
 @param api 请求api
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)getWithUrl:(NSString *)urlString Api:(NSString *)api successBlock:(void (^)(NSURLSessionDataTask *task, id responseObject, NSInteger statusCode))successBlock failureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

/**
 post请求
 
 @param urlString url网址
 @param api 请求API
 @param parmertes 上传字典
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)postWithUrl:(NSString *)urlString Api:(NSString *)api bodyData:(NSData *)bodyData theParmeters:(NSDictionary *)parmertes uploadProgress:(void (^)(double uploadProgress)) uploadProgressBlock downloadProgress:(void (^)(double downloadProgress)) downloadProgressBlock successBlock:(void (^)( id responseObject, NSInteger statusCode))successBlock failureBlock:(void (^)( NSError *error))failureBlock;


/**
 put请求
 
 @param urlString url网址
 @param api 请求API
 @param parmertes 上传字典
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)putWithUrl:(NSString *)urlString Api:(NSString *)api theParmeters:(NSDictionary *)parmertes successBlock:(void (^)(NSURLSessionDataTask *task, id responseObject, NSInteger statusCode))successBlock failureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;


/**
 delete请求
 
 @param urlString url网址
 @param api 请求API
 @param parmertes 上传字典
 @param successBlock 成功回调
 @param failureBlock 失败回调
 */
+ (void)deleteWithUrl:(NSString *)urlString Api:(NSString *)api theParmeters:(NSDictionary *)parmertes successBlock:(void (^)(NSURLSessionDataTask *task, id responseObject, NSInteger statusCode))successBlock failureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

@end
