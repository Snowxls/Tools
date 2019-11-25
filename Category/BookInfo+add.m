//
//  BookInfo+add.m
//  PDFReader
//
//  Created by 王放歌 on 2019/5/19.
//  Copyright © 2019年 com.chineseall.www. All rights reserved.
//

#import "BookInfo+add.h"

@implementation BookInfo (add)
- (BOOL)deleteBookFile{
    if (self.state != DOWNLOAD_SUCCESS) {
        return YES;
    }
    UserInfo *user = [[ConfigManager sharedInstance] getCurrentUser];
    NSString *homeDir = NSHomeDirectory();
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager removeItemAtPath:[NSString stringWithFormat:@"%@%@",homeDir,self.fileName] error:nil]) {
        if ([self.fileName hasSuffix:@"dcz"]) {
            //移除dcz解压文件夹
            NSString *fileName = [self.fileName substringToIndex:(self.fileName.length - 4)];
            [fileManager removeItemAtPath:[homeDir stringByAppendingString:fileName] error:nil];
        }
        NSLog(@"书本文件删除成功");
        //删除之前的资源文件&目录文件
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsPath = [paths objectAtIndex:0];
        NSString *directoryPath = [NSString stringWithFormat:@"books/%@_Directory.txt",self.bookId];
        NSString *resourcePath = [NSString stringWithFormat:@"books/%@_Resource.txt",self.bookId];
        NSString *directoryFile = [documentsPath stringByAppendingPathComponent:directoryPath];
        NSString *resourceFile = [documentsPath stringByAppendingPathComponent:resourcePath];
        //删除目录文件
        [fileManager removeItemAtPath:directoryFile error:nil];
        //删除资源文件
        [fileManager removeItemAtPath:resourceFile error:nil];
        //删除resource 和 残留文件
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/Resources/%@",documentsPath,self.bookId] error:nil];
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@%@",homeDir,self.bookCoverPath] error:nil];
        
        //删除用户对应文件
        if ([fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/Documents/%@/%@",homeDir,user.userId,self.bookId] error:nil]) {
            NSLog(@"用户对应文件夹删除成功");
//            return YES;
        } else {
            NSLog(@"用户对应文件夹删除失败");
//            return NO;
        }
        return YES;
    }
    return NO;
}
@end
