//
//  FGImageCache.h
//  PDFReader
//
//  Created by 王放歌 on 2019/6/13.
//  Copyright © 2019 com.chineseall.www. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FGImageCacheManager : NSObject
/**
 *单例获取方法
 */
+(instancetype _Nullable)sharedInstance;


/**
 添加image到内存中

 @param image 需要添加的图片
 @param key 关键字
 */
- (void)setCacheImage:(UIImage *_Nonnull)image key:(NSString *_Nonnull)key;


/**
 根据关键字获取缓存的图片

 @param key 关键字
 @return 获取到的image 未获取到为nil
 */
- (UIImage *_Nullable)getCacheImageForKey:(NSString *_Nonnull)key;


/**
 清除所有缓存图片
 */
-(void)clearCache;
@end

