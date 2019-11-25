//
//  NSObject+Data.m
//  PDFReader
//
//  Created by Snow WarLock on 2018/12/3.
//  Copyright © 2018 com.chineseall.www. All rights reserved.
//

#import "NSObject+Data.h"

@implementation NSObject (Data)

+ (void)load{
//    NSString *bookFile = [NSString stringWithFormat:@"%@/books",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    NSString * bookFile = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:BookPath]];
    NSString * coversPath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:CoverPath]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:bookFile]) {
        //创建books文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:bookFile withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:coversPath]) {
        //创建coversPath文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:coversPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
}
+ (NSData *)getDataWithDictionary:(NSDictionary *)dic {
    if (dic == nil) {
        return nil;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

+ (NSData *)getDataWithArray:(NSArray *)arr {
    NSString *jsonString = @"[";
    for (NSString *s in arr) {
        jsonString = [jsonString stringByAppendingString:s];
        jsonString = [jsonString stringByAppendingString:@","];
    }
    jsonString = [jsonString substringToIndex:([jsonString length]-1)];
    jsonString = [jsonString stringByAppendingString:@"]"];
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}


#pragma mark Tools
+ (BOOL)writeBookResourceWithBookId:(NSString *)bookId Dictionary:(NSDictionary*)dic {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/books/%@_Resource.txt",documentsPath,bookId];
    NSString *json = [NetTools convertToJsonData:dic];
    
    BOOL isWrite = [json writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return isWrite;
}

+ (BOOL)writeBookDirectoryWithBookId:(NSString *)bookId Dictionary:(NSDictionary*)dic {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/books/%@_Directory.txt",documentsPath,bookId];
    NSString *json = [NetTools convertToJsonData:dic];
    
    BOOL isWrite = [json writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return isWrite;
}
+ (BOOL)bookDirectoryIsFileExistWithBookId:(NSString *)bookId{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/books/%@_Directory.txt",documentsPath,bookId];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

+ (BOOL)writeBookStrWithUserLoginName:(NSString*)loginName String:(NSString*)str FileName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@.txt",loginName,fileName];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:path];
    
    BOOL isWrite = [str writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return isWrite;
}

+ (BOOL)writeBookStrWithUserLoginName:(NSString*)loginName FileName:(NSString *)fileName forDictionary:(NSDictionary*)dic {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@.txt",loginName,fileName];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:path];
    NSString *json = [NetTools convertToJsonData:dic];
    BOOL isWrite = [json writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return isWrite;
}
+ (NSDictionary *)readBookStrWithUserLoginName:(NSString*)loginName FileName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/%@.txt",loginName,fileName];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:path];
    NSString *json = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return [NetTools dictionaryWithJsonString:json];
}

+ (BOOL)writeGatewayToDocument:(NSArray *)GatewayArr{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"/%@.txt",@"GatewayArr"];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:path];
    NSString *json = [NetTools convertToJsonData:GatewayArr];
    BOOL isWrite = [json writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return isWrite;
    
}

+ (NSArray *)readGatewayToDocument{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"/%@.txt",@"GatewayArr"];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:path];
    NSString *json = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    return [NetTools arrayWithJsonString:json];
}

+ (BOOL)isFileExistForName:(NSString *)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    BOOL result = [self isFileExistForPath:filePath];
    return result;
}

//判断文件是否已经在沙盒中已经存在？
-(BOOL)isFileExistForPath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件是否存在：%@",result?@"存在":@"不存在");
    return result;
}

+ (BOOL)writeUserInfoToPlistWithUserName:(NSString *)userName Dictionary:(NSDictionary*)dic {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/info.txt",userName];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:path];
    NSString *json = [NetTools convertToJsonData:dic];
    
    BOOL isWrite = [json writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return isWrite;
}

+ (NSString *)readInfoTxtWithUserName:(NSString*)userName {
    NSError *error1;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"%@/info.txt",userName];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:path];
    
    NSString *str =  [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error1];
    
    return str;
}

+ (BOOL)createUserFolderWithUserId:(NSString*)userId {
    BOOL isCreate = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [documentsPath stringByAppendingPathComponent:userId];
    isCreate = [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    return isCreate;
}

@end
