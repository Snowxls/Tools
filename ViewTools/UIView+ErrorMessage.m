//
//  UIView+Empty.m
//  PDFReader
//
//  Created by 酌晨茗 on 2018/9/12.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import "UIView+ErrorMessage.h"

static UILabel *kMessagelabel;

@implementation UIView (ErrorMessage)

- (void)showErrorMessage:(NSString *)message edge:(UIEdgeInsets)edge {
    if (kMessagelabel) {
        [self dismissErrorMessage];
    }
    
    kMessagelabel = [[UILabel alloc] initWithFrame:CGRectMake(edge.left, edge.top + (self.height - edge.top - edge.bottom - 50) / 2.0, self.width - edge.left - edge.right, 50)];
    kMessagelabel.textAlignment = NSTextAlignmentCenter;
    kMessagelabel.text = message;
    kMessagelabel.textColor = [UIColor grayColor];
    [self addSubview:kMessagelabel];
}

- (void)changeErrorMessage:(NSString *)message {
    kMessagelabel.text = message;
    kMessagelabel.backgroundColor = [UIColor clearColor];
    [self bringSubviewToFront:kMessagelabel];
}

- (void)setErrorMessageBackgroundColor:(UIColor*)color {
    kMessagelabel.layer.cornerRadius = 4;
//    kMessagelabel.backgroundColor = color;
}

- (void)dismissErrorMessage {
    if (!kMessagelabel) {
        return;
    }
    kMessagelabel.backgroundColor = [UIColor clearColor];
    [kMessagelabel removeFromSuperview];
    kMessagelabel = nil;
}

@end
