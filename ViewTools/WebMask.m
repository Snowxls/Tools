//
//  WebMask.m
//  PDFReader
//
//  Created by Snow WarLock on 2018/11/28.
//  Copyright © 2018 com.chineseall.www. All rights reserved.
//

#import "WebMask.h"

@interface WebMask () {
    UILabel *lv_message;
}

@end

@implementation WebMask

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
    self.backgroundColor = [UIColor colorWithARGB:R_color_lightGray];
    
    lv_message = [[UILabel alloc] initWithFrame:self.frame];
    lv_message.textAlignment = NSTextAlignmentCenter;
    lv_message.textColor = [UIColor grayColor];
    [self addSubview:lv_message];
}

- (void)setMessage:(NSString *)message {
    lv_message.text = message;
}

@end
