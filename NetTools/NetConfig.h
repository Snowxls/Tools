//
//  NetConfig.h
//  PDFReader
//
//  Created by Snow WarLock on 2018/5/15.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^UpProgressBlock) (NSProgress* progress);
typedef void(^DownProgressBlock) (NSProgress* progress);
typedef void(^SuccessBlock) (NSURLSessionDataTask *task, id responseObject);
typedef void(^FailureBlock) (NSURLSessionDataTask *task, NSError *error);
typedef void(^FailureBlock2) (NSURLSessionDataTask *task, NSError *error,id responseObject);

@interface NetConfig : NSObject

+ (void)getKeySuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

+ (void)postURL:(NSString *)url Api:(NSString *)api Key:(NSString *)key Body:(NSDictionary*)body Parameters:(id)parameters UpProgressBlock:(UpProgressBlock)upProgressBlock DownProgressBlock:(DownProgressBlock)downProgressBlock SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

+ (void)postURL:(NSString *)url Api:(NSString *)api Key:(NSString *)key BodyArr:(NSMutableArray*)bodyArr Parameters:(id)parameters UpProgressBlock:(UpProgressBlock)upProgressBlock DownProgressBlock:(DownProgressBlock)downProgressBlock SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

+ (void)postURL:(NSString *)url Api:(NSString *)api Key:(NSString *)key Token:(NSString*)token Body:(NSDictionary*)body Parameters:(id)parameters UpProgressBlock:(UpProgressBlock)upProgressBlock DownProgressBlock:(DownProgressBlock)downProgressBlock SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

+ (void)getURL:(NSString *)url Api:(NSString *)api Key:(NSString *)key Body:(NSDictionary*)body Parameters:(id)parameters DownProgressBlock:(DownProgressBlock)downProgressBlock SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

+ (void)getURL:(NSString *)url Api:(NSString *)api Key:(NSString *)key Token:(NSString*)token Parameters:(id)parameters DownProgressBlock:(DownProgressBlock)downProgressBlock SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

+ (void)requestWithMethod:(NSString*)method URL:(NSString *)url Api:(NSString *)api Key:(NSString *)key Body:(NSDictionary*)body Parameters:(id)parameters UpProgressBlock:(UpProgressBlock)upProgressBlock DownProgressBlock:(DownProgressBlock)downProgressBlock SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

+ (void)uploadFileWithPath:(NSString*)path SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

+ (void)uploadUserHeadWithFilePath:(NSString*)path SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

//+ (void)uploadLogWithJsonArray:(NSMutableArray*)jsonArray SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock2)failureBlock;

+ (void)PostHeartBeatWithUrl:(NSString *)url Body:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

@end
