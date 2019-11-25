//
//  FGImageCache.m
//  PDFReader
//
//  Created by 王放歌 on 2019/6/13.
//  Copyright © 2019 com.chineseall.www. All rights reserved.
//

#import "FGImageCacheManager.h"

@interface FGImageCacheManager ()

@property (nonatomic,strong) NSMutableDictionary *imageCacheDic;

@end
@implementation FGImageCacheManager

static FGImageCacheManager *manager;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [super allocWithZone:zone];
        }
    });
    return manager;
}

+ (instancetype) sharedInstance {
    return [[self alloc] init];
}

// 为了严谨，也要重写copyWithZone 和 mutableCopyWithZone
- (id)copyWithZone:(NSZone *)zone {
    return manager;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return manager;
}

- (NSMutableDictionary *)imageCacheDic{
    if (_imageCacheDic == nil) {
        _imageCacheDic = [[NSMutableDictionary alloc] init];
    }
    return _imageCacheDic;
}

- (void)setCacheImage:(UIImage *_Nonnull)image key:(NSString *_Nonnull)key{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.imageCacheDic setObject:image forKey:key];
    });
    
}

- (UIImage *_Nullable)getCacheImageForKey:(NSString *_Nonnull)key{
    UIImage *image = [self.imageCacheDic objectForKey:key];
    return image;
}

-(void)clearCache{
    
    dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageCacheDic removeAllObjects];
    });
}
@end
