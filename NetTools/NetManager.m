//
//  NetManager.m
//  PDFReader
//
//  Created by Snow WarLock on 2018/11/21.
//  Copyright © 2018 com.chineseall.www. All rights reserved.
//

#import "NetManager.h"
#import "UserInfo.h"
#import "ConfigManager.h"

@implementation NetManager

+ (void)getKeySuccessBlock:(Success)successBlock failureBlock:(Failure)failureBlock {
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSDate *d = [NSDate date];
    
    long long num = [NetTools getDateTimeTOMilliSeconds:d]+10*60*1000;
    NSString *numString =[NSString stringWithFormat:@"%lld",num];
    
    NSString *md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&context=%@&security_key=%@",numString,KeyUrl,AppId]];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,KeyUrl];
    
    __block AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __block __weak NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    
    [req setValue:numString forHTTPHeaderField:@"CHINESEALL_SIGN_EXP"];
    [req setValue:md5String forHTTPHeaderField:@"CHINESEALL_SIGN"];
    [req setValue:AppId forHTTPHeaderField:@"APP_ID"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        
        if (!error) {
            successBlock(nil,responseObject,responseStatusCode);
        } else {
            if (responseObject == nil) {
                failureBlock(nil,error,responseObject,responseStatusCode);
            } else {
                successBlock(nil,responseObject,responseStatusCode);
            }
        }
    }] resume];
}

+ (void)postURL:(NSString *)url Api:(NSString *)api Token:(NSString*)token Body:(id)body Parameters:(id)parameters UpProgressBlock:(UpProgress)upProgressBlock DownProgressBlock:(DownProgress)downProgressBlock SuccessBlock:(Success)successBlock failureBlock:(Failure)failureBlock {
    NSDate *d = [NSDate date];
    
    long long num = [NetTools getDateTimeTOMilliSeconds:d]+10*60*1000;
    NSString *numString =[NSString stringWithFormat:@"%lld",num];
    
    NSString *key = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppKey"];
    if (key.length == 0) {
        key = @"";
    }
    
    NSString *md5String;
    
    if (token.length == 0) {
        md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&context=%@&security_key=%@",numString,api,key]];
    } else {
        md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&CHINESEALL_TOKEN=%@&context=%@&security_key=%@",numString,token,api,key]];
    }
    
    
    __block AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __block __weak NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];
    
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:numString forHTTPHeaderField:@"CHINESEALL_SIGN_EXP"];
    [req setValue:md5String forHTTPHeaderField:@"CHINESEALL_SIGN"];
    [req setValue:AppId forHTTPHeaderField:@"APP_ID"];
    [req setValue:token forHTTPHeaderField:@"CHINESEALL_TOKEN"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if ([body isKindOfClass:[NSDictionary class]]) {
        if (body != nil) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        }
    } else if ([body isKindOfClass:[NSArray class]] || [body isKindOfClass:[NSMutableArray class]]) {
        NSArray *bodyArr = body;
        if (bodyArr.count > 0) {
            NSString *jsonString = @"[";
            for (NSString *s in bodyArr) {
                jsonString = [jsonString stringByAppendingString:s];
                jsonString = [jsonString stringByAppendingString:@","];
            }
            jsonString = [jsonString substringToIndex:([jsonString length]-1)];
            jsonString = [jsonString stringByAppendingString:@"]"];
            [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        upProgressBlock(uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        downProgressBlock(downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        if (!error) {
            successBlock(nil,responseObject,responseStatusCode);
        } else {
            failureBlock(nil,error,responseObject,responseStatusCode);
        }
    }] resume];
    
}

+ (void)getURL:(NSString *)url Api:(NSString *)api Token:(NSString*)token Parameters:(id)parameters DownProgressBlock:(DownProgress)downProgressBlock SuccessBlock:(Success)successBlock failureBlock:(Failure)failureBlock {
    
    NSDate *d = [NSDate date];
    
    long long num = [NetTools getDateTimeTOMilliSeconds:d]+10*60*1000;
    NSString *numString = [NSString stringWithFormat:@"%lld",num];
    
    NSString *key = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppKey"];
    if (key.length == 0) {
        key = @"";
    }
    
    NSString *md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&CHINESEALL_TOKEN=%@&context=%@&security_key=%@",numString,token,api,key]];
    
    // 初始化对象
    __block __weak AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 返回的格式 JSON
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    // 开始设置请求头
    [manager.requestSerializer setValue:numString forHTTPHeaderField:@"CHINESEALL_SIGN_EXP"];
    [manager.requestSerializer setValue:md5String forHTTPHeaderField:@"CHINESEALL_SIGN"];
    [manager.requestSerializer setValue:AppId forHTTPHeaderField:@"APP_ID"];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"CHINESEALL_TOKEN"];
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        downProgressBlock(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = urlResponse.statusCode;
        successBlock(task,responseObject,statusCode);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
        NSInteger statusCode = urlResponse.statusCode;
        failureBlock(task,error,nil,statusCode);
    }];
}

+ (void)requestWithMethod:(NSString*)method URL:(NSString *)url Api:(NSString *)api Token:(NSString*)token Body:(id)body Parameters:(id)parameters UpProgressBlock:(UpProgress)upProgressBlock DownProgressBlock:(DownProgress)downProgressBlock SuccessBlock:(Success)successBlock failureBlock:(Failure)failureBlock {
    NSDate *d = [NSDate date];
    
    long long num = [NetTools getDateTimeTOMilliSeconds:d]+10*60*1000;
    NSString *numString =[NSString stringWithFormat:@"%lld",num];
    
    NSString *key = [[NSUserDefaults standardUserDefaults] valueForKey:@"AppKey"];
    if (key.length == 0) {
        key = @"";
    }
    
    NSString *md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&CHINESEALL_TOKEN=%@&context=%@&security_key=%@",numString,token,api,key]];
    
    __block AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __block __weak NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:url parameters:parameters error:nil];
    
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:numString forHTTPHeaderField:@"CHINESEALL_SIGN_EXP"];
    [req setValue:md5String forHTTPHeaderField:@"CHINESEALL_SIGN"];
    [req setValue:AppId forHTTPHeaderField:@"APP_ID"];
    [req setValue:token forHTTPHeaderField:@"CHINESEALL_TOKEN"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if ([body isKindOfClass:[NSDictionary class]]) {
        if (body != nil) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        }
    } else if ([body isKindOfClass:[NSArray class]] || [body isKindOfClass:[NSMutableArray class]]) {
        NSArray *bodyArr = body;
        if (bodyArr.count > 0) {
            NSString *jsonString = @"[";
            for (NSString *s in bodyArr) {
                jsonString = [jsonString stringByAppendingString:s];
                jsonString = [jsonString stringByAppendingString:@","];
            }
            jsonString = [jsonString substringToIndex:([jsonString length]-1)];
            jsonString = [jsonString stringByAppendingString:@"]"];
            [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        upProgressBlock(uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        downProgressBlock(downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        if (!error) {
            successBlock(nil,responseObject,responseStatusCode);
        } else {
            failureBlock(nil,error,responseObject,responseStatusCode);
        }
    }] resume];
}

+ (void)uploadFileWithPath:(NSString*)path SchoolId:(NSString*)schoolId UpProgressBlock:(UpProgress)upProgressBlock DownProgressBlock:(DownProgress)downProgressBlock SuccessBlock:(Success)successBlock failureBlock:(Failure)failureBlock {
    
    NSString *fileName = [path lastPathComponent];
    
    fileName = [fileName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",UploadBase,fileName];
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    
    NSLog(@"%lu",(unsigned long)fileData.length);
    long long MaxFile = 1024*1024*200;
    NSString *err = @"超过200M的文件";
    if (fileData.length > MaxFile) {
        successBlock(nil,err,9999);
        return;
    }
    
    __block AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __block __weak NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:[NetTools getFileMD5WithPath:path] forHTTPHeaderField:@"Content-MD5"];
    [req setValue:schoolId forHTTPHeaderField:@"OrgID"];
    [req setValue:@"text/json" forHTTPHeaderField:@"Content-type"];
    
    [req setHTTPBody:fileData];
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        upProgressBlock(uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        downProgressBlock(downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        if (!error) {
            successBlock(nil,responseObject,responseStatusCode);
        } else {
            failureBlock(nil,error,responseObject,responseStatusCode);
        }
    }] resume];
}

+ (void)uploadUserHeadWithFilePath:(NSString*)path UserId:(NSString*)userId UpProgressBlock:(UpProgress)upProgressBlock DownProgressBlock:(DownProgress)downProgressBlock SuccessBlock:(Success)successBlock failureBlock:(Failure)failureBlock {
    NSString *fileName = [path lastPathComponent];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",AppSupport,UpdateHead];
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    
    __block AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __block __weak NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:[NetTools getFileMD5WithPath:path] forHTTPHeaderField:@"Content-MD5"];
    [req setValue:userId forHTTPHeaderField:@"user_id"];
    [req setValue:ClientId forHTTPHeaderField:@"client_id"];
    [req setValue:fileName forHTTPHeaderField:@"file_name"];
    [req setValue:@"text/json" forHTTPHeaderField:@"Content-type"];
    //TODO token
    
    [req setHTTPBody:fileData];
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        upProgressBlock(uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        downProgressBlock(downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        if (!error) {
            successBlock(nil,responseObject,responseStatusCode);
        } else {
            failureBlock(nil,error,responseObject,responseStatusCode);
        }
    }] resume];
}

@end
