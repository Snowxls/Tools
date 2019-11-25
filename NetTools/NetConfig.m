//
//  NetConfig.m
//  PDFReader
//
//  Created by Snow WarLock on 2018/5/15.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import "NetConfig.h"
#import "UserInfo.h"
#import "ConfigManager.h"
#import "FGNetConfig.h"
@implementation NetConfig

+ (void)getKeySuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    NSDate *d = [NSDate date];
    
    long long num = [NetTools getDateTimeTOMilliSeconds:d]+10*60*1000;
    NSString *numString =[NSString stringWithFormat:@"%lld",num];
    
    //CHINESEALL_SIGN_EXP=1488455418512&context   security_key=SNfzx9CP5LfBCGZ1&CHINESEALL_SIGN_EXP=[NSString stringWithFormat:@"%ld",num]&/api/t&security_key=aaaa
    NSString *md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&context=/api/v1/app/security/key&security_key=%@",numString,AppId]];
    
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"cer"];
//    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//
//    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//    if (certData) {
//        securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];
//    }
    
    // 初始化对象
    __block __weak AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//     [manager setSecurityPolicy:securityPolicy];
    // 返回的格式 JSON
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];

    // 开始设置请求头
    [manager.requestSerializer setValue:numString forHTTPHeaderField:@"CHINESEALL_SIGN_EXP"];//当前时间转秒+10分钟后的数值
    [manager.requestSerializer setValue:md5String forHTTPHeaderField:@"CHINESEALL_SIGN"];//按照固定格式生成的字符转 md5加密
    [manager.requestSerializer setValue:AppId forHTTPHeaderField:@"APP_ID"];//固定的AppId

    NSLog(@"%@",manager.requestSerializer.HTTPRequestHeaders);

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,KeyUrl];
    
    [manager GET:url parameters:nil  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
        NSLog(@"responseObject is %@", responseObject);
        NSLog(@"the responseObject class is %@", [responseObject class]);
        NSDictionary *responsedic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
        NSLog(@"the response state code is %ld", (long)urlResponse.statusCode);
        
        NSLog(@"the responseDic is %@", responsedic);
        
        successBlock(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
        NSLog(@"the response state code is %ld", (long)urlResponse.statusCode);
        
        __block AFURLSessionManager *ma = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        __block __weak NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
        
        [req setValue:numString forHTTPHeaderField:@"CHINESEALL_SIGN_EXP"];
        [req setValue:md5String forHTTPHeaderField:@"CHINESEALL_SIGN"];
        [req setValue:AppId forHTTPHeaderField:@"APP_ID"];
        
        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [[ma dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (!error) {
                successBlock(nil,responseObject);
            } else {
                if (responseObject == nil) {
                    failureBlock(nil,error);
                } else {
                    successBlock(nil,responseObject);
                }
            }
        }] resume];
    }];
}

+ (void)postURL:(NSString *)url Api:(NSString *)api Key:(NSString *)key Body:(NSDictionary*)body Parameters:(id)parameters UpProgressBlock:(UpProgressBlock)upProgressBlock DownProgressBlock:(DownProgressBlock)downProgressBlock SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    
    NSDate *d = [NSDate date];
    
    long long num = [NetTools getDateTimeTOMilliSeconds:d]+10*60*1000;
    NSString *numString =[NSString stringWithFormat:@"%lld",num];
    
    NSString *md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&context=%@&security_key=%@",numString,api,key]];
    
    __block AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __block __weak NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];
    
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:numString forHTTPHeaderField:@"CHINESEALL_SIGN_EXP"];
    [req setValue:md5String forHTTPHeaderField:@"CHINESEALL_SIGN"];
    [req setValue:AppId forHTTPHeaderField:@"APP_ID"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if (body != nil) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        upProgressBlock(uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        downProgressBlock(downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSInteger responseStatusCode = [httpResponse statusCode];
        NSLog(@"%ld",responseStatusCode);
        
        if (!error) {
            successBlock(nil,responseObject);
        } else {
            failureBlock(nil,error);
        }
    }] resume];
    
//    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] init];
//    // 开始设置请求头
//    [headerDic setObject:numString forKey:@"CHINESEALL_SIGN_EXP"];//当前时间转秒+10分钟后的数值
//    [headerDic setObject:md5String forKey:@"CHINESEALL_SIGN"];//按照固定格式生成的字符转 md5加密
//    [headerDic setObject:AppId forKey:@"APP_ID"];//固定的AppId
//    [headerDic setObject:@"application/json" forKey:@"Content-Type"];
//    [headerDic setObject:@"application/json" forKey:@"Accept"];
//    NSData *bodyData;
//    if (body != nil) {
//        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        bodyData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    }
//    [FGNetConfig postWithUrl:url headerDic:headerDic bodyData:bodyData theParmeters:parameters successBlock:^(id responseObject, NSInteger statusCode) {
//        successBlock(nil,responseObject);
//    } failureBlock:^(NSError *error) {
//        failureBlock(nil,error);
//    }];
    
}

+ (void)postURL:(NSString *)url Api:(NSString *)api Key:(NSString *)key BodyArr:(NSMutableArray*)bodyArr Parameters:(id)parameters UpProgressBlock:(UpProgressBlock)upProgressBlock DownProgressBlock:(DownProgressBlock)downProgressBlock SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    
    NSDate *d = [NSDate date];
    
    long long num = [NetTools getDateTimeTOMilliSeconds:d]+10*60*1000;
    NSString *numString =[NSString stringWithFormat:@"%lld",num];
    
    NSString *md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&context=%@&security_key=%@",numString,api,key]];
    
    __block AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __block __weak NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];
    
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:numString forHTTPHeaderField:@"CHINESEALL_SIGN_EXP"];
    [req setValue:md5String forHTTPHeaderField:@"CHINESEALL_SIGN"];
    [req setValue:AppId forHTTPHeaderField:@"APP_ID"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if (bodyArr.count > 0) {
//        NSError *error;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
        NSString *jsonString = @"[";
        for (NSString *s in bodyArr) {
            jsonString = [jsonString stringByAppendingString:s];
            jsonString = [jsonString stringByAppendingString:@","];
        }
        jsonString = [jsonString substringToIndex:([jsonString length]-1)];
        jsonString = [jsonString stringByAppendingString:@"]"];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        upProgressBlock(uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        downProgressBlock(downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            successBlock(nil,responseObject);
        } else {
            failureBlock(nil,error);
        }
    }] resume];
}

+ (void)postURL:(NSString *)url Api:(NSString *)api Key:(NSString *)key Token:(NSString*)token Body:(NSDictionary*)body Parameters:(id)parameters UpProgressBlock:(UpProgressBlock)upProgressBlock DownProgressBlock:(DownProgressBlock)downProgressBlock SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    NSDate *d = [NSDate date];
    
    long long num = [NetTools getDateTimeTOMilliSeconds:d]+10*60*1000;
    NSString *numString =[NSString stringWithFormat:@"%lld",num];
    
    NSString *md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&context=%@&security_key=%@",numString,api,key]];
    
    __block AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __block __weak NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];
    
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:numString forHTTPHeaderField:@"CHINESEALL_SIGN_EXP"];
    [req setValue:md5String forHTTPHeaderField:@"CHINESEALL_SIGN"];
    [req setValue:AppId forHTTPHeaderField:@"APP_ID"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:token forHTTPHeaderField:@"token"];
    
    if (body != nil) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        upProgressBlock(uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        downProgressBlock(downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            successBlock(nil,responseObject);
        } else {
            failureBlock(nil,error);
        }
    }] resume];
}

+ (void)getURL:(NSString *)url Api:(NSString *)api Key:(NSString *)key Body:(NSDictionary *)body Parameters:(id)parameters DownProgressBlock:(DownProgressBlock)downProgressBlock SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    
    NSDate *d = [NSDate date];
    
    long long num = [NetTools getDateTimeTOMilliSeconds:d]+10*60*1000;
    NSString *numString =[NSString stringWithFormat:@"%lld",num];
    
    //CHINESEALL_SIGN_EXP=1488455418512&context   security_key=SNfzx9CP5LfBCGZ1&CHINESEALL_SIGN_EXP=[NSString stringWithFormat:@"%ld",num]&/api/t&security_key=aaaa
    NSString *md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&context=%@&security_key=%@",numString,api,key]];
    NSLog(@"%@",[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&context=%@&security_key=%@",numString,api,key]);
    // 初始化对象
    __block __weak AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 返回的格式 JSON
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    // 开始设置请求头
    [manager.requestSerializer setValue:numString forHTTPHeaderField:@"CHINESEALL_SIGN_EXP"];
    [manager.requestSerializer setValue:md5String forHTTPHeaderField:@"CHINESEALL_SIGN"];
    [manager.requestSerializer setValue:AppId forHTTPHeaderField:@"APP_ID"];
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        downProgressBlock(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task,error);
    }];
    
}

+ (void)getURL:(NSString *)url Api:(NSString *)api Key:(NSString *)key Token:(NSString*)token Parameters:(id)parameters DownProgressBlock:(DownProgressBlock)downProgressBlock SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    NSDate *d = [NSDate date];
    
    long long num = [NetTools getDateTimeTOMilliSeconds:d]+10*60*1000;
    NSString *numString =[NSString stringWithFormat:@"%lld",num];
    
    //CHINESEALL_SIGN_EXP=1488455418512&context   security_key=SNfzx9CP5LfBCGZ1&CHINESEALL_SIGN_EXP=[NSString stringWithFormat:@"%ld",num]&/api/t&security_key=aaaa
    NSString *md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&context=%@&security_key=%@",numString,api,key]];
    
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
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        downProgressBlock(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task,error);
    }];
}

+ (void)requestWithMethod:(NSString*)method URL:(NSString *)url Api:(NSString *)api Key:(NSString *)key Body:(NSDictionary*)body Parameters:(id)parameters UpProgressBlock:(UpProgressBlock)upProgressBlock DownProgressBlock:(DownProgressBlock)downProgressBlock SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    NSDate *d = [NSDate date];
    
    long long num = [NetTools getDateTimeTOMilliSeconds:d]+10*60*1000;
    NSString *numString =[NSString stringWithFormat:@"%lld",num];
    
    NSString *md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&context=%@&security_key=%@",numString,api,key]];
    
    __block AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __block __weak NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:url parameters:parameters error:nil];
    
    
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [req setValue:numString forHTTPHeaderField:@"CHINESEALL_SIGN_EXP"];
    [req setValue:md5String forHTTPHeaderField:@"CHINESEALL_SIGN"];
    [req setValue:AppId forHTTPHeaderField:@"APP_ID"];
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if (body != nil) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        upProgressBlock(uploadProgress);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        downProgressBlock(downloadProgress);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            successBlock(nil,responseObject);
        } else {
            failureBlock(nil,error);
        }
    }] resume];
}

+ (void)uploadFileWithPath:(NSString *)path SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    UserInfo *user = [[ConfigManager sharedInstance] getCurrentUser];
    NSString *schoolId = @"";//[NSString stringWithFormat:@"%ld",(long)user.schoolId];
    if (schoolId.length == 0) {
        schoolId = @"0";
    }
    
    NSString *fileName = [path lastPathComponent];
    
    fileName = [fileName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",UploadBase,fileName];
    NSData *fileData = [NSData dataWithContentsOfFile:path];

    NSLog(@"%ld",fileData.length);
    long long MaxFile = 1024*1024*200;
    NSString *err = @"超过200M的文件";
    if (fileData.length > MaxFile) {
        successBlock(nil,err);
        return;
    }
    
    NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:0 timeoutInterval:15.f];
    
    [uploadRequest setHTTPMethod:@"POST"];
    
    [uploadRequest addValue:[NetTools getFileMD5WithPath:path] forHTTPHeaderField:@"Content-MD5"];
    [uploadRequest addValue:schoolId forHTTPHeaderField:@"OrgID"];
    [uploadRequest addValue:@"text/json" forHTTPHeaderField:@"Content-type"];
    [uploadRequest setHTTPBody:fileData];
    
    NSURLSession *_globalSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *uploadDataTask = [_globalSession dataTaskWithRequest:uploadRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//        NSInteger responseStatusCode = [httpResponse statusCode];
//        NSLog(@"%d", responseStatusCode);
//        
//        NSLog(@" http response : %d",httpResponse.statusCode);
        
        
        if (!error) {
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                successBlock(nil,dict);
            } else {
                failureBlock(nil,error);
            }
        } else {
            failureBlock(nil,error);
        }
        
        
    }];
    
    [uploadDataTask resume];
    
}

+ (void)uploadUserHeadWithFilePath:(NSString *)path SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {
    UserInfo *user = [[ConfigManager sharedInstance] getCurrentUser];
    NSString *userId = user.userId;
    NSString *fileName = [path lastPathComponent];
    
    NSString *url = [NSString stringWithFormat:@"%@/api/2/upload_user_icon",AppSupport];
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    
    NSMutableURLRequest *uploadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:0 timeoutInterval:15.f];
    
    [uploadRequest setHTTPMethod:@"POST"];
    
    [uploadRequest addValue:[NetTools getFileMD5WithPath:path] forHTTPHeaderField:@"content_md5"];
    [uploadRequest addValue:userId forHTTPHeaderField:@"user_id"];
    [uploadRequest addValue:ClientId forHTTPHeaderField:@"client_id"];
    [uploadRequest addValue:fileName forHTTPHeaderField:@"file_name"];
    [uploadRequest addValue:@"text/json" forHTTPHeaderField:@"Content-type"];
    [uploadRequest addValue:[[ConfigManager sharedInstance] getToken] forHTTPHeaderField:@"token"];
    [uploadRequest setHTTPBody:fileData];
    
    NSURLSession *_globalSession = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *uploadDataTask = [_globalSession dataTaskWithRequest:uploadRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSLog(@"%@",response);
        if (!error) {
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                successBlock(nil,dict);
            } else {
                failureBlock(nil,error);
            }
        } else {
            failureBlock(nil,error);
        }
        
        
    }];
    
    [uploadDataTask resume];
}

//+ (void)uploadLogWithJsonArray:(NSMutableArray*)jsonArray SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock2)failureBlock {
//
//    NSString *url = [NSString stringWithFormat:@"%@%@",UploadLogBase,UploadLog];
//
//    __block AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//
//    __block __weak NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
//
//    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
//
//    [req setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
//    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//
//    NSString *jsonString = @"[";
//    for (NSString *s in jsonArray) {
//        jsonString = [jsonString stringByAppendingString:s];
//        jsonString = [jsonString stringByAppendingString:@","];
//    }
//    jsonString = [jsonString substringToIndex:([jsonString length]-1)];
//    jsonString = [jsonString stringByAppendingString:@"]"];
//    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
//
////    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSUTF8StringEncoding error:nil];
////    [req setHTTPBody:jsonData];
//
//
//    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
//
//    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        if (!error) {
//            successBlock(nil,responseObject);
//        } else {
//            failureBlock(nil,error,responseObject);
//        }
//    }] resume];
//}

+ (void)PostHeartBeatWithUrl:(NSString *)url Body:(NSDictionary *)dic SuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock {

    __block AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    __block __weak NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];


    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];


    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    if (dic != nil) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    }

    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {

    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {

    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            successBlock(nil,responseObject);
        } else {
            failureBlock(nil,error);
        }
    }] resume];

}


@end
