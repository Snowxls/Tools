//
//  NSTimer+Tools.m
//  PDFReader
//
//  Created by Snow WarLock on 2018/3/23.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import "NSTimer+Tools.h"

@implementation NSTimer (Tools)

- (void)pauseTimer {
    
    //如果已被释放则return！isValid对应invalidate
    if (![self isValid]) return;
    //启动时间为很久以后
    [self setFireDate:[NSDate distantFuture]];
}

- (void)continueTimer {
    
    if (![self isValid]) return;
    //启动时间为现在
    [self setFireDate:[NSDate date]];
}

@end
