//
//  UIImageView+Tools.h
//  PDFReader
//
//  Created by Snow WarLock on 2018/3/20.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>

@interface UIImageView (Tools)

/**
 获取视频缩略图
 @param pathUrl 视频路径
 */
+(UIImage *)getVideoPreViewImageWithVideoUrl:(NSURL *)pathUrl ;

/**
 获取视频缩略图
 @param pathUrl 视频路径
 @param block 回调Image
 */
+ (void)getVideoImageWithVideoUrl:(NSURL *)pathUrl callBack:(void(^)(UIImage *image))block;

/**
 获取视频第n秒的缩略图
 @param videoURL 视频路径
 @param time 时间
 */
+(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/**
 获取视频缩略图
 @param URLString 视频路径
 @param block 回调Image
 */
- (void)setVideoImageWithVideoURLString:(NSString *)URLString callBack:(void(^)(UIImage *image))block;

/**
 获取视频缩略图
 @param videoURL 视频路径
 @param block 回调Image
 */
- (void)setVideoImageWithVideoURL:(NSURL *)videoURL callBack:(void(^)(UIImage *image))block;

/**
 加载高清图片

 @param URLString URL字符串
 @param placeholderImage 置位图
 @param size 缩略图大小
 @param block image为原图，thumImage为缩略图
 */
- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholderImage thumSize:(CGSize)size callBack:(void(^)(UIImage *image, UIImage *thumImage))block;

/**
 图片缩放
 @param image 需要处理的Image
 @param asize 需要缩放到的Size
 */
- (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;

@end
