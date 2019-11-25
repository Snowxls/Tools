//
//  FGAppVersionManager.h
//  PDFReader
//
//  Created by 王放歌 on 2019/6/14.
//  Copyright © 2019 com.chineseall.www. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FGAppVersionManager : NSObject
/**
 *单例获取方法
 */
+(instancetype _Nullable)sharedInstance;


/**
 检测更新

 @param isSuccessPrompting 是否手动点击检测
 */
- (void)checkFroUpdatesIsSuccessPrompting:(BOOL)isSuccessPrompting;


@end

