//
//  UIImageView+Tools.m
//  PDFReader
//
//  Created by Snow WarLock on 2018/3/20.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import "UIImageView+Tools.h"
#import "UIView+WebCache.h"

@implementation UIImageView (Tools)

+ (UIImage *)getVideoPreViewImageWithVideoUrl:(NSURL *)pathUrl {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:pathUrl options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];

    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

+ (void)getVideoImageWithVideoUrl:(NSURL *)pathUrl callBack:(void(^)(UIImage *image))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:pathUrl options:nil];
        AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        
        assetGen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(videoImage);
            }
        });
    });
}

+(UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    NSParameterAssert(asset);
    AVAssetImageGenerator *assetImageGenerator =[[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    CFTimeInterval thumbnailImageTime = time;
    NSError *thumbnailImageGenerationError = nil;
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60)actualTime:NULL error:&thumbnailImageGenerationError];
    
    if(!thumbnailImageRef)
        NSLog(@"thumbnailImageGenerationError %@",thumbnailImageGenerationError);
    
    UIImage*thumbnailImage = thumbnailImageRef ? [[UIImage alloc]initWithCGImage: thumbnailImageRef] : nil;
    
    return thumbnailImage;
}

- (void)setVideoImageWithVideoURLString:(NSString *)URLString callBack:(void(^)(UIImage *image))block {
    NSURL *videoURL = [NSURL URLWithString:URLString];
    [self setVideoImageWithVideoURL:videoURL callBack:block];
}
- (void)setVideoImageWithVideoURL:(NSURL *)videoURL callBack:(void(^)(UIImage *image))block {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
        AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        
        assetGen.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
        CGImageRelease(image);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *thumImage = [self scaleImage:videoImage toSize:self.frame.size];
            self.image = thumImage;
            if (block) {
                block(thumImage);
            }
        });
    });
}

- (void)setImageWithURLString:(NSString *)URLString placeholderImage:(UIImage *)placeholderImage thumSize:(CGSize)size callBack:(void(^)(UIImage *image, UIImage *thumImage))block {
    [self sd_internalSetImageWithURL:[NSURL URLWithString:URLString] placeholderImage:placeholderImage options:0 operationKey:nil setImageBlock:^(UIImage * _Nullable image, NSData * _Nullable imageData) {
        UIImage *thumImage = [self scaleImage:image toSize:size];
        self.image = thumImage;
        block(image, thumImage);
    } progress:nil completed:nil];
}

- (UIImage *)scaleImage:(UIImage *)sourceImage toSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [sourceImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    } else {
        UIGraphicsBeginImageContext(asize);
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

@end
