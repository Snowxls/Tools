//
//  SegmentControl.h
//  getLocal
//
//  Created by Snow WarLock on 2019/4/15.
//  Copyright © 2019 Chineseall. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentControlDelegate <NSObject>

- (void)segmentDidChangeWithIndex:(NSInteger)index;

@end

@interface SegmentControl : UIView

/**
 初始化
 @param frame 位置信息
 @param titles 标题数组
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles;

/**
 初始化
 @param frame 位置信息
 @param titles 标题数组
 */
- (instancetype)initUnOutlineSegmentWithFrame:(CGRect)frame titles:(NSArray<NSString *> *)titles;

/**
 设置标题数组
 @param titles 标题数组
 */
- (void)setTitles:(NSArray<NSString *> *)titles;

@property (nonatomic,weak) id<SegmentControlDelegate> delegate;
@property (nonatomic,readwrite) NSInteger selectedSegmentIndex;

@end
