//
//  SegmentControl.m
//  getLocal
//
//  Created by Snow WarLock on 2019/4/15.
//  Copyright © 2019 Chineseall. All rights reserved.
//

#import "SegmentControl.h"

@interface SegmentControl (){
    NSArray *mTitles;
    NSMutableArray *mButtons;
    UIView *bg;
    UIView *mask;
    NSInteger currentIndex;
    
    BOOL unOutline;
}

@end

@implementation SegmentControl

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        mTitles = titles;
        mButtons = [NSMutableArray array];
        currentIndex = 0;
        [self createUI];
    }
    return self;
}

- (instancetype)initUnOutlineSegmentWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        mTitles = titles;
        mButtons = [NSMutableArray array];
        currentIndex = 0;
        [self createUnOutlineUI];
    }
    return self;
}

- (void)createUI {
    self.layer.cornerRadius = self.frame.size.height/2;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    bg = [[UIView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width-4, self.frame.size.height-4)];
    bg.layer.cornerRadius = (self.frame.size.height-4)/2;
    bg.layer.masksToBounds = YES;
    [self addSubview:bg];
    
    CGFloat width = (self.frame.size.width-4)/mTitles.count;
    CGFloat height = self.frame.size.height-4;
    
    mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [mask az_setGradientBackgroundWithColors:@[[UIColor colorWithARGB:R_color_LightBlue],[UIColor colorWithARGB:R_color_DarkBlue]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    mask.layer.cornerRadius = height/2;
    mask.clipsToBounds = YES;
    [bg addSubview:mask];
    
    for (int i = 0;i < mTitles.count;i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        [btn setTitle:mTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithARGB:R_color_blue] forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [self MainFontWithSize:18];
        btn.tag = 10000+i;
        if (i == 0) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:btn];
        [mButtons addObject:btn];
    }
}

- (void)createUnOutlineUI {
//    self.layer.cornerRadius = self.frame.size.height/2;
//    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    unOutline = YES;
    
    bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:bg];
    
    CGFloat width = (self.frame.size.width-4)/mTitles.count;
    CGFloat height = self.frame.size.height-4;
    
    mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
//    [mask az_setGradientBackgroundWithColors:@[[UIColor colorWithARGB:R_color_LightBlue],[UIColor colorWithARGB:R_color_DarkBlue]] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    mask.backgroundColor = [UIColor whiteColor];
    mask.layer.cornerRadius = 4;
    mask.clipsToBounds = YES;
    [bg addSubview:mask];
    
    for (int i = 0;i < mTitles.count;i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        [btn setTitle:mTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor colorWithARGB:R_color_blue] forState:UIControlStateSelected];
        btn.titleLabel.font = [self MainFontWithSize:18];
        btn.tag = 10000+i;
        btn.layer.cornerRadius = 4;
        if (i == 0) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:btn];
        [mButtons addObject:btn];
    }
}

- (void)setTitles:(NSArray<NSString *> *)titles {
    mTitles = titles;
    for (UIButton *btn in mButtons) {
        [btn removeFromSuperview];
    }
    [mButtons removeAllObjects];
    CGFloat width = (self.frame.size.width-4)/mTitles.count;
    CGFloat height = self.frame.size.height-4;
    for (int i = 0;i < mTitles.count;i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        [btn setTitle:mTitles[i] forState:UIControlStateNormal];
        if (!unOutline) {
            [btn setTitleColor:[UIColor colorWithARGB:R_color_blue] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        } else {
            [btn setTitleColor:[UIColor colorWithARGB:R_color_blue] forState:UIControlStateSelected];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        btn.titleLabel.font = [self MainFontWithSize:18];
        btn.tag = 10000+i;
        if (i == 0) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(touchBtn:) forControlEvents:UIControlEventTouchUpInside];
        [bg addSubview:btn];
        [mButtons addObject:btn];
    }
    
}

- (void)touchBtn:(UIButton *)btn {
    NSInteger index = btn.tag - 10000;
    if (currentIndex == index) {
        return;
    }
    for (UIButton *btn in mButtons) {
        btn.selected = NO;
    }
    btn.selected = YES;
    currentIndex = index;
    if (self.delegate) {
        [self.delegate segmentDidChangeWithIndex:index];
    }
    NSInteger i = btn.tag - 10000;
    CGFloat width = (self.frame.size.width-4)/mTitles.count;
    CGFloat height = self.frame.size.height-4;
    [UIView animateWithDuration:0.2 animations:^{
        self->mask.frame = CGRectMake(i*width, 0, width, height);
    }];
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    if (selectedSegmentIndex >= mTitles.count) {
        return;
    }
    currentIndex = selectedSegmentIndex;
    for (UIButton *btn in mButtons) {
        btn.selected = NO;
        if (btn.tag == selectedSegmentIndex + 10000) {
            btn.selected = YES;
        }
    }
    CGFloat width = (self.frame.size.width-4)/mTitles.count;
    CGFloat height = self.frame.size.height-4;
    mask.frame = CGRectMake(selectedSegmentIndex*width, 0, width, height);
}

- (NSInteger)selectedSegmentIndex {
    return currentIndex;
}

@end
