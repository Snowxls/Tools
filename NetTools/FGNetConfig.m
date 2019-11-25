//
//  FGNetConfig.m
//  PDFReader
//
//  Created by 王放歌 on 2018/11/21.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import "FGNetConfig.h"
#import "ConfigManager.h"
#import "loginHttpClient.h"
//#import "LoginViewController.h"
#import "UUMenuController.h"

@implementation FGNetConfig

+ (void)getKeySuccessBlock:(void (^)(id responseObject, NSInteger statusCode))successBlock failureBlock:(void (^)( NSError *error,id responseObject, NSInteger statusCode))failureBlock {
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    NSDate *d = [NSDate date];
    
    long long num = [NetTools getDateTimeTOMilliSeconds:d]+10*60*1000;
    NSString *numString =[NSString stringWithFormat:@"%lld",num];
    
    NSString *md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&context=%@&security_key=%@",numString,KeyUrl,AppId]];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseUrl,KeyUrl];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
   NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:url parameters:nil error:nil];
    
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
            successBlock(responseObject,responseStatusCode);
        } else {
            if (responseObject == nil) {
                failureBlock(error,responseObject,responseStatusCode);
            } else {
                successBlock(responseObject,responseStatusCode);
            }
        }
    }] resume];
}

+ (NSDictionary *)getHeadDicAppContext:(NSString *)context{
    
    NSMutableDictionary *headerDic = [[NSMutableDictionary alloc] init];
    NSString *timeString = [FGNetConfig getNumString];
    // 开始设置请求头
    [headerDic setObject:timeString forKey:@"CHINESEALL_SIGN_EXP"];//设置过期时间
    
    [headerDic setObject:[FGNetConfig getMd5StringAppContext:context timeStr:timeString] forKey:@"CHINESEALL_SIGN"];//按照固定格式生成的字符转 md5加密
    if ([[ConfigManager sharedInstance] getToken].length > 0) {
        
        [headerDic setObject:[[ConfigManager sharedInstance] getToken] forKey:@"CHINESEALL_TOKEN"];//存在token时设置
    }
    [headerDic setObject:AppId forKey:@"APP_ID"];//固定的AppId
    
    [headerDic setObject:@"iOS" forKey:@"APP_SYSTEM"]; //用于识别机器类别
    
    return headerDic;
}
/**
 获取超时时间
 
 @return 时间string
 */
+ (NSString *)getNumString{
    
    NSDate *d = [NSDate date];
    long long num = [NetTools getDateTimeTOMilliSeconds:d]+10*60*1000;//当前时间转秒+10分钟后的数值
    return [NSString stringWithFormat:@"%lld",num];
}

/**
 获取签名字符串
 
 @param context 接口context
 @return 签名字符串
 */
+ (NSString *)getMd5StringAppContext:(NSString *)context timeStr:(NSString *)timeStr{
    
    NSString *key;
    if ([[ConfigManager sharedInstance] getMainKey].length == 0) {
        key = AppId;
    }else{
        key = [[ConfigManager sharedInstance] getMainKey];
    }
    NSString *md5String;
    if ([[ConfigManager sharedInstance] getToken].length == 0) {
        md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&CONTEXT=%@&SECURITY_KEY=%@",timeStr,context,key]];
    } else {
        md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&CHINESEALL_TOKEN=%@&CONTEXT=%@&SECURITY_KEY=%@",timeStr,[[ConfigManager sharedInstance] getToken],context,key]];
    }
    
//    if ([[ConfigManager sharedInstance] getToken].length == 0) {
//        md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&context=%@&security_key=%@",timeStr,context,key]];
//    } else {
//        md5String = [NetTools md5:[NSString stringWithFormat:@"CHINESEALL_SIGN_EXP=%@&CHINESEALL_TOKEN=%@&context=%@&security_key=%@",timeStr,[[ConfigManager sharedInstance] getToken],context,key]];
//    }
    
    return md5String;
}

+ (void)backToRootViewController{

}
#pragma mark 数据请求

+ (NSURLSessionDataTask *)jsonWithrequestWithMethod:(NSString *)method Url:(NSString *)urlString Api:(NSString *)api bodyData:(NSData *)bodyData theParmeters:(NSDictionary *)parmertes uploadProgress:(void (^)(double uploadProgress)) uploadProgressBlock downloadProgress:(void (^)(double downloadProgress)) downloadProgressBlock successBlock:(void (^)(id responseObject, NSInteger statusCode))successBlock failureBlock:(void (^)( NSError *error,id responseObject, NSInteger statusCode))failureBlock {
    // 初始化对象
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:urlString parameters:parmertes error:nil];
    
    req.timeoutInterval = [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    NSDictionary *headerDic = [self getHeadDicAppContext:api];
    // 开始设置请求头
    for (NSString *key in headerDic.allKeys) {
        if (key.length) {
            [req setValue:headerDic[key] forHTTPHeaderField:key];
        }
    }
    
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    if (bodyData != nil) {
        [req setHTTPBody:bodyData];
    }
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            uploadProgressBlock(uploadProgress.fractionCompleted);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            downloadProgressBlock(downloadProgress.fractionCompleted);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse =(NSHTTPURLResponse *)response;
        NSDictionary *head = httpResponse.allHeaderFields;
        NSString *tokenStr = [head valueForKey:@"CHINESEALL_TOKEN"];
        if (tokenStr) {
            NSDictionary *tokenDic = [NetTools dictionaryUnSymbolWithJsonString:tokenStr];
            if (tokenDic) {
                NSString *token = @"";
                token = [tokenDic valueForKey:@"token"];
                if (token.length > 0) {
                    [[ConfigManager sharedInstance] setToken:token];
                    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"APP_TOKEN"];
                    UserInfo *currentUser = [[ConfigManager sharedInstance] getCurrentUser];
                    currentUser.token = token;
                    NSDictionary *plistDic = [currentUser getObjectData:currentUser];
                    [self writeUserInfoToPlistWithUserName:currentUser.userId Dictionary:plistDic];
                }
            }
        }
        
        if (!error) {
            successBlock(responseObject,httpResponse.statusCode);
        } else {
            if (responseObject) {
                NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
                if (code == 998) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        DQAlertView *av = [[DQAlertView alloc] initWithTitle:@"提示" message:@"登录状态过期，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                        [av show];
                    });
                }else{
                    failureBlock(error,responseObject,httpResponse.statusCode);
                }
                
            }else{
                failureBlock(error,responseObject,httpResponse.statusCode);
            }
        }

    }];
    [task resume];
    return task;
}

+ (void)getWithUrl:(NSString *)urlString Api:(NSString *)api successBlock:(void (^)(NSURLSessionDataTask *task, id responseObject, NSInteger statusCode))successBlock failureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    // 初始化对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 返回的格式 JSON
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    // 可接受的文本参数规格
//    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    NSDictionary *headerDic = [self getHeadDicAppContext:api];

    // 开始设置请求头
    for (NSString *key in headerDic.allKeys) {
        
        if (key.length) {
            [manager.requestSerializer setValue:headerDic[key] forHTTPHeaderField:key];
        }
        
    }
    NSLog(@"%@",manager.requestSerializer.HTTPRequestHeaders);
    // 返回的格式 JSON
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    // 可接受的文本参数规格
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        NSError *errorForJSON = [NSError errorWithDomain:@"请求数据解析为json格式，发出错误" code:2014 userInfo:@{@"请求数据json解析错误": @"中文",@"serial the data to json error":@"English"}];
//        NSLog(@"responseObject is %@", responseObject);
//        NSLog(@"the responseObject class is %@", [responseObject class]);
//        NSDictionary *responsedic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
        successBlock(task,responseObject,urlResponse.statusCode);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(task,error);
        
    }];
}


+ (void)postWithUrl:(NSString *)urlString Api:(NSString *)api bodyData:(NSData *)bodyData theParmeters:(NSDictionary *)parmertes uploadProgress:(void (^)(double uploadProgress)) uploadProgressBlock downloadProgress:(void (^)(double downloadProgress)) downloadProgressBlock successBlock:(void (^)( id responseObject, NSInteger statusCode))successBlock failureBlock:(void (^)( NSError *error))failureBlock{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    // 初始化对象
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:POST_M URLString:urlString parameters:parmertes error:nil];
    NSDictionary *headerDic = [self getHeadDicAppContext:api];
    // 开始设置请求头
    for (NSString *key in headerDic.allKeys) {
        
        if (key.length) {
            [req setValue:headerDic[key] forHTTPHeaderField:key];
        }
        
    }
    
    if (bodyData != nil) {
        [req setHTTPBody:bodyData];
    }
    
    [[manager dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        uploadProgressBlock(uploadProgress.fractionCompleted);
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        downloadProgressBlock(downloadProgress.fractionCompleted);
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            successBlock(responseObject,11);
        } else {
            failureBlock(error);
        }
    }] resume];

}


+ (void)putWithUrl:(NSString *)urlString Api:(NSString *)api theParmeters:(NSDictionary *)parmertes successBlock:(void (^)(NSURLSessionDataTask *task, id responseObject, NSInteger statusCode))successBlock failureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    // 初始化对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *headerDic = [self getHeadDicAppContext:api];
    // 开始设置请求头
    for (NSString *key in headerDic.allKeys) {
        
        if (key.length) {
            [manager.requestSerializer setValue:headerDic[key] forHTTPHeaderField:key];
        }
        
    }
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    NSLog(@"%@",manager.requestSerializer.HTTPRequestHeaders);
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager PUT:urlString parameters:parmertes success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
        successBlock(task,responseObject,urlResponse.statusCode);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         failureBlock(task,error);
    }];
    
}

    + (void)deleteWithUrl:(NSString *)urlString Api:(NSString *)api theParmeters:(NSDictionary *)parmertes successBlock:(void (^)(NSURLSessionDataTask *task, id responseObject, NSInteger statusCode))successBlock failureBlock:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock{
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        // 初始化对象
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *headerDic = [self getHeadDicAppContext:api];
        // 开始设置请求头
        for (NSString *key in headerDic.allKeys) {
            
            if (key.length) {
                [manager.requestSerializer setValue:headerDic[key] forHTTPHeaderField:key];
            }
            
        }
        NSLog(@"%@",manager.requestSerializer.HTTPRequestHeaders);
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager DELETE:urlString parameters:parmertes success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)task.response;
            successBlock(task,responseObject,urlResponse.statusCode);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failureBlock(task,error);
        }];
    }

+ (void)cancelButtonClickedOnAlertView:(DQAlertView *)alertView{
    
    UUMenuController *menu = [UUMenuController sharedMenuController];
    if (menu.menuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
    
    //密码错误，跳转到登录页
    [self backToRootViewController];
    
}

@end
