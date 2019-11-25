//
//  NetManager.h
//  PDFReader
//
//  Created by Snow WarLock on 2018/11/21.
//  Copyright © 2018 com.chineseall.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^UpProgress) (NSProgress* progress);
typedef void(^DownProgress) (NSProgress* progress);
typedef void(^Success) (NSURLSessionDataTask *task, id responseObject, NSInteger StatusCode);
typedef void(^Failure) (NSURLSessionDataTask *task, NSError *error, id responseObject, NSInteger StatusCode);

@interface NetManager : NSObject

+ (void)getKeySuccessBlock:(Success)successBlock failureBlock:(Failure)failureBlock;

+ (void)postURL:(NSString *)url Api:(NSString *)api Token:(NSString*)token Body:(id)body Parameters:(id)parameters UpProgressBlock:(UpProgress)upProgressBlock DownProgressBlock:(DownProgress)downProgressBlock SuccessBlock:(Success)successBlock failureBlock:(Failure)failureBlock;

+ (void)getURL:(NSString *)url Api:(NSString *)api Token:(NSString*)token Parameters:(id)parameters DownProgressBlock:(DownProgress)downProgressBlock SuccessBlock:(Success)successBlock failureBlock:(Failure)failureBlock;

+ (void)requestWithMethod:(NSString*)method URL:(NSString *)url Api:(NSString *)api Token:(NSString*)token Body:(id)body Parameters:(id)parameters UpProgressBlock:(UpProgress)upProgressBlock DownProgressBlock:(DownProgress)downProgressBlock SuccessBlock:(Success)successBlock failureBlock:(Failure)failureBlock;

+ (void)uploadFileWithPath:(NSString*)path SchoolId:(NSString*)schoolId UpProgressBlock:(UpProgress)upProgressBlock DownProgressBlock:(DownProgress)downProgressBlock SuccessBlock:(Success)successBlock failureBlock:(Failure)failureBlock;

+ (void)uploadUserHeadWithFilePath:(NSString*)path UserId:(NSString*)userId UpProgressBlock:(UpProgress)upProgressBlock DownProgressBlock:(DownProgress)downProgressBlock SuccessBlock:(Success)successBlock failureBlock:(Failure)failureBlock;

@end
