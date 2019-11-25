//
//  ProgressLog.m
//  PDFReader
//
//  Created by Snow WarLock on 2018/5/21.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import "ProgressLog.h"

@interface ProgressLog (){
    UIView *mask;
    UIView *content;
    UILabel *log;
}

@end

@implementation ProgressLog

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMask)];
    mask.userInteractionEnabled = YES;
//    mask.backgroundColor = [UIColor redColor];
    [mask addGestureRecognizer:tap];
    [self addSubview:mask];
    
    content = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [self uiWidthBy:420], [self uiHeightBy:80])];
    content.backgroundColor = [UIColor colorWithARGB:0x99000000];
    content.layer.cornerRadius = 4;
    content.center = self.center;
    [self addSubview:content];
    
    log = [[UILabel alloc] initWithFrame:CGRectMake([self uiWidthBy:10],0, [self uiWidthBy:400], [self uiHeightBy:80])];
    log.textColor = [UIColor whiteColor];
    log.textAlignment = NSTextAlignmentCenter;
    log.font = [self MainFontWithSize:18];
    [content addSubview:log];
}

- (void)setLog:(NSString *)logStr {
    log.text = logStr;
}

- (void)tapMask {
    
}

- (CGFloat)uiWidthBy:(CGFloat)width {
    return [[UIScreen mainScreen] widthByScale:(width / 2048.0f)];
}

- (CGFloat)uiHeightBy:(CGFloat)height {
    return [[UIScreen mainScreen] heightByScale:(height / 1536.0f)];
}

@end
