//
//  NSObject+Data.h
//  PDFReader
//
//  Created by Snow WarLock on 2018/12/3.
//  Copyright © 2018 com.chineseall.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Data)

/**
 字典转JsonData
 @param dic 字典模型
 */
+ (NSData *)getDataWithDictionary:(NSDictionary *)dic;

/**
 数组转JsonData
 @param arr 数组模型
 */
+ (NSData *)getDataWithArray:(NSArray *)arr;

/**
 将资源文件内容写入书本对应文件
 @param bookId 书本Id
 @param dic 将要写入的Json字典数据
 */
+ (BOOL)writeBookResourceWithBookId:(NSString *)bookId Dictionary:(NSDictionary*)dic;

/**
 将目录文件内容写入书本对应文件
 @param bookId 书本Id
 @param dic 将要写入的Json字典数据
 */
+ (BOOL)writeBookDirectoryWithBookId:(NSString *)bookId Dictionary:(NSDictionary*)dic;

/**
 判断是否存在书本对应目录文件
 @param bookId 书本Id
 */
+ (BOOL)bookDirectoryIsFileExistWithBookId:(NSString *)bookId;

/**
 将文件写入用户文件夹内
 @param loginName 用户登录名
 @param str 写入的内容
 @param fileName 文件名
 */
+ (BOOL)writeBookStrWithUserLoginName:(NSString*)loginName String:(NSString*)str FileName:(NSString *)fileName;

/**
 将文件写入用户文件夹内
 @param loginName 用户登录名
 @param fileName 文件名
 @param dic 写入发Json字典
 */
+ (BOOL)writeBookStrWithUserLoginName:(NSString*)loginName FileName:(NSString *)fileName forDictionary:(NSDictionary*)dic;

/**
 读取文件内容
 @param loginName 用户登录名
 @param fileName 文件名
 */
+ (NSDictionary *)readBookStrWithUserLoginName:(NSString*)loginName FileName:(NSString *)fileName;


+ (BOOL)writeGatewayToDocument:(NSArray *)GatewayArr;

+ (NSArray *)readGatewayToDocument;

/**
 文件是否存在
 @param fileName 文件名
 */
+ (BOOL)isFileExistForName:(NSString *)fileName;

/**
 路径文件是否存在
 @param filePath 文件路径
 */
-(BOOL)isFileExistForPath:(NSString *)filePath;

/**
 用户基础信息写入
 @param userName 用户名
 @param dic 写入的Json字典
 */
+ (BOOL)writeUserInfoToPlistWithUserName:(NSString *)userName Dictionary:(NSDictionary*)dic;

/**
 读取用户基础信息
 @param userName 用户名
 */
+ (NSString *)readInfoTxtWithUserName:(NSString*)userName;

/**
 创建用户文件夹
 @param userId 用户Id
 */
+ (BOOL)createUserFolderWithUserId:(NSString*)userId;

@end

