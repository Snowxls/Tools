//
//  MuAnnotationModel+noteFrom.h
//  PDFReader
//
//  Created by 王放歌 on 2018/9/26.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import "MuAnnotationModel.h"
@class NoteModel;
@class MuPageScrollView;
@interface MuAnnotationModel (noteFrom)

/**
 本地笔记转mupdf model

 @param model notemodel
 @param size 图片size
 @return 转换后的model
 */
+ (NoteModel *)FromNoteModel:(NoteModel *)model andImageSize:(CGSize)size;

/**
 获取当前图书的系统资源

 @return 系统资源array 
 */
+ (NSArray<MuAnnotationModel *> *)getSystemResourcePageScrollView:(MuPageScrollView *)pageScrollView;


/**
 mumodel 转lineModel

 @return 转换后的model
 */
- (NoteModel *)muModelFromLineNoteModel;


/**
 将自由画笔model中的line保存到数据库，非自由画笔model禁止调用
 */
- (void)saveFreeLineDataToDB;

@end
