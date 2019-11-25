//
//  MuAnnotationModel+noteFrom.m
//  PDFReader
//
//  Created by 王放歌 on 2018/9/26.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import "MuAnnotationModel+noteFrom.h"
#import "NoteModel.h"
#import "ConfigManager.h"
#import "MuPageScrollView.h"
#import "NoteManager.h"
@implementation MuAnnotationModel (noteFrom)

+ (NoteModel *)FromNoteModel:(NoteModel *)note andImageSize:(CGSize)size{
    
//    MuAnnotationModel *m;
    if (note.noteType == NoteTypeLine) {    //画线高亮
//        m = [[MuAnnotationModel alloc] init];
        note.modelID = [note.noteId longLongValue];
        if (note.serverId.length > 0) {
            note.serverID = [NSString stringWithFormat:@"%@",note.serverId];
        }
        note.page = note.page;
        note.labelString = note.markStr;
        note.string = note.content;
        note.renderSize = CGSizeMake(note.pageWidth, note.pageHeight);
//        note.renderSize = CGSizeMake(595, 841);
        [note stringToMarks];
        if (note.lineType == LineType_Line) {
            note.type = kAnnotationTypeLine;
            note.lineHeight = 1;
            note.color = [[ConfigManager sharedInstance] getLineARGBColorWithColor:note.lineColor];
        } else if (note.lineType == LineType_Wave) {
            note.type = kAnnotationTypeWavyLine;
            note.lineHeight = 1;
            note.color = [[ConfigManager sharedInstance] getLineARGBColorWithColor:note.lineColor];
        } else if (note.lineType == LineType_Dotted) {
            note.type = kAnnotationTypeDottedLine;
            note.lineHeight = 1;
            note.color = [[ConfigManager sharedInstance] getLineARGBColorWithColor:note.lineColor];
        } else if (note.lineType == LineType_Highlight) {
            note.type = kAnnotationTypeHightlight;
            note.color = [[ConfigManager sharedInstance] getHightlightAlphaColorWithColor:note.lineColor];
        }
        
        NSArray *array = [NetTools arrayWithJsonString:note.coord];
        NSMutableArray *coords = [RectCoord getSelfWithArray:array];
        NSMutableArray *rects = [NSMutableArray array];
        for (RectCoord *rc in coords) {
            CGRect r = CGRectMake(rc.x, rc.y, rc.w, rc.h);
            NSString *rString = NSStringFromCGRect(r);
            [rects addObject:rString];
        }
        [note.rectArray addObjectsFromArray:rects];
        note.noteString = note.notation;
        return note;
    }else if(note.noteType == NoteTypeFree) {    //自由画笔
//        m = [MuAnnotationModel modelWithStyle:kAnnotationTypeFreedomLine page:note.page];
        note.type = kAnnotationTypeFreedomLine;
        note.modelID = [note.noteId longLongValue];
        note.sourceType = note.noteType;
        if (note.serverId.length > 0) {
            note.serverID = [NSString stringWithFormat:@"%@",note.serverId];
        }
        note.renderSize = CGSizeMake(note.pageWidth, note.pageHeight);
        NSMutableArray *lineArr = [NSMutableArray array];
        NSMutableArray *colorArr = [NSMutableArray array];
        NSMutableArray *widthArr = [NSMutableArray array];
        
//        NSArray *array = [NetTools arrayWithJsonString:note.coord];
//        NSMutableArray *coords = [FreeCoord getSelfWithArray:array];
        NSArray *coords = [[NoteManager sharedInstance] freetableGetLinesWithNoteId:note.noteId];
        for (FreeCoord *fc in coords) {
            NSMutableArray *point2Line = [NSMutableArray array];
            for (PointCoord *pc in fc.line) {
                CGPoint p = CGPointMake(pc.x, pc.y);
                NSString *ps = NSStringFromCGPoint(p);
                [point2Line addObject:ps];
            }
            NSMutableArray *line = [NSMutableArray array];
            [line addObject:point2Line];
            [lineArr addObject:line];
            
            UIColor *lineColor = [[ConfigManager sharedInstance] getARGBColorWithColor:fc.color];
            [colorArr addObject:lineColor];
            
            CGFloat lineWidth = [[ConfigManager sharedInstance] getFreeLineWidthWith:fc.width];
            NSNumber *lw = [NSNumber numberWithFloat:lineWidth];
            [widthArr addObject:lw];
        }
        
        note.lineArray = lineArr;
        note.colorArray = colorArr;
        note.lineWidthArray = widthArr;
        return note;
    }
    
//  带图标的附件等
    
//    m = [MuAnnotationModel modelWithStyle:kAnnotationTypeImage page:note.page];
    note.type = kAnnotationTypeImage;
    note.modelID = [note.noteId longLongValue];
    note.sourceType = note.noteType;
    note.labelString = note.markStr;
    [note stringToMarks];
    
    if (note.serverId.length > 0) {
        note.serverID = [NSString stringWithFormat:@"%@",note.serverId];
    }
    NSDictionary *dic = [NetTools dictionaryUnSymbolWithJsonString:note.coord];
    RectCoord *rc = [RectCoord getSelfWithDictionary:dic];
    CGFloat x = rc.x - size.width/2;
    CGFloat y = rc.y - size.height/2;
    CGRect r = CGRectMake(x, y, size.width, size.height);
    note.rect = r;
    note.renderSize = CGSizeMake(note.pageWidth, note.pageHeight);
    note.noteString = note.notation;
    
    if (note.noteType == NoteTypeTextBox) {
        
        note.sourceImage = [UIImage imageNamed:@"text_normal"];
    } else if (note.noteType == NoteTypePicture) {
        
        note.filePath = note.path;
        note.sourceImage = [UIImage imageNamed:@"pic_normal"];
    } else if (note.noteType == NoteTypeVideo) {
        
        note.filePath = note.path;
        note.sourceImage = [UIImage imageNamed:@"video_normal"];
    } else if (note.noteType == NoteTypeAudio) {
        
        note.filePath = note.path;
        note.sourceImage = [UIImage imageNamed:@"audio_normal"];
        
    }else if (note.noteType == NoteTypeFile) {
       
        note.filePath = note.path;
        
        NSString *suffix = note.path.pathExtension;
        if ([suffix isEqualToString:@"pptx"] || [suffix isEqualToString:@"PPTX"] || [suffix isEqualToString:@"ppt"] || [suffix isEqualToString:@"PPT"]) {
            note.sourceImage = [UIImage imageNamed:@"ppt__enclosure_n"];
        } else if ([suffix isEqualToString:@"doc"] || [suffix isEqualToString:@"DOC"] || [suffix isEqualToString:@"docx"] || [suffix isEqualToString:@"DOCX"]) {
            note.sourceImage = [UIImage imageNamed:@"word__enclosure_n"];
        } else if ([suffix isEqualToString:@"xls"] || [suffix isEqualToString:@"XLS"] || [suffix isEqualToString:@"xlsx"] || [suffix isEqualToString:@"XLSX"]) {
            note.sourceImage = [UIImage imageNamed:@"excel_enclosure_n"];
        } else if ([suffix isEqualToString:@"pdf"] || [suffix isEqualToString:@"PDF"]) {
            note.sourceImage = [UIImage imageNamed:@"pdf_enclosure_n"];
        } else {
            note.sourceImage = [UIImage imageNamed:@"other_enclosure_n"];
        }
    } else if (note.noteType == NoteTypeLink) {
        note.string = note.content;
        note.filePath = note.path;
        note.sourceImage = [UIImage imageNamed:@"data_normal"];
    }
    
    
    return note;
}

+ (NSArray<MuAnnotationModel *> *)getSystemResourcePageScrollView:(MuPageScrollView *)pageScrollView{
    
    NSError *error1;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path = [NSString stringWithFormat:@"books/%@_Resource.txt",[[ConfigManager sharedInstance] getCurrentBookId]];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:path];
    
    NSString *str =  [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error1];
    NSMutableArray *resourceNotes = [NSMutableArray array];
    if (str.length > 0) {
        NSDictionary *nDic = [NetTools dictionaryWithJsonString:str];
        if (nDic == nil) {
            NSLog(@"解析错误");
        }else{
            NSArray *arr = [nDic valueForKey:@"pages"];
            
            for (NSDictionary *dic in arr) {
                NSArray *notes = [dic valueForKey:@"regions"];
                CGFloat width = [[dic valueForKey:@"width"] floatValue];
                CGFloat height = [[dic valueForKey:@"height"] floatValue];
                NSInteger page = [[dic valueForKey:@"page_no"] integerValue]-1;
                if (notes.count > 0) {
                    for (NSDictionary *dDic in notes) {
                        NSString *basePath = [dDic valueForKey:@"path"];
                        NSString *fileName = [dDic valueForKey:@"file_name"];
                        CGFloat x = [[dDic valueForKey:@"position_x"] floatValue];
                        CGFloat y = [[dDic valueForKey:@"position_y"] floatValue];
                        
                        CGSize size = [pageScrollView findGridSizeWithPage:page originalWidth:width];
                        
                        MuAnnotationModel *m = [MuAnnotationModel modelWithStyle:kAnnotationTypeImage page:page];
                        m.sourceType = NoteTypeSystemResource;
                        m.rect = CGRectMake(x-size.width/2, y-size.height/2, size.width, size.height);
                        //                    m.viewWidth = width;
                        m.renderSize = CGSizeMake(width, height);
                        m.noteString = [dDic valueForKey:@"item_name"];
                        m.filePath = [NSString stringWithFormat:@"%@%@",basePath,fileName];
                        m.sourceImage = [UIImage imageNamed:@"voice_normal"];
                        m.panEnable = NO;
                        m.isCanHidden = NO;
                        [resourceNotes addObject:m];
                    }
                }
            }
            
        }
    }
    return [[NSArray alloc] initWithArray:resourceNotes];
}


- (NoteModel *)muModelFromLineNoteModel{
    NoteModel *note = [[NoteModel alloc] init];
    note.noteId = [NSString stringWithFormat:@"%lld",self.modelID];
    note.noteType = NoteTypeLine;
    note.lineType = [[ConfigManager sharedInstance] getLineType];
    note.content = self.string;
    note.page = self.page;
    note.timeDate = [NSDate date];
    note.lineColor = [[ConfigManager sharedInstance] getLineColor];
    NSString *coord = @"[";
    for (int i=0;i<self.rectArray.count;i++) {
        NSString *s = self.rectArray[i];
        CGRect r = CGRectFromString(s);
        RectCoord *rc = [[RectCoord alloc] init];
        rc.x = r.origin.x;
        rc.y = r.origin.y;
        rc.w = r.size.width;
        rc.h = r.size.height;
        NSDictionary *d = [rc getObjectData:rc];
        NSString *json = [NetTools convertToJsonData:d];
        coord = [coord stringByAppendingString:json];
        coord = [coord stringByAppendingString:@","];
    }
    
    if (coord.length > 0) {
        coord = [coord substringWithRange:NSMakeRange(0, [coord length] - 1)];
    }
    coord = [coord stringByAppendingString:@"]"];
    coord = [coord stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    for (int i=0;i<model.rectArray.count;i++) {
    //        NSString *r = model.rectArray[i];
    //        if (i != model.rectArray.count -1) {
    //            rects = [rects stringByAppendingString:[NSString stringWithFormat:@"%@&",r]];
    //        } else {
    //            rects = [rects stringByAppendingString:r];
    //        }
    //    }
    note.coord = coord;
    note.pageWidth = self.renderSize.width;
    note.pageHeight = self.renderSize.height;
    return note;
}

- (void)saveFreeLineDataToDB{
    NSArray *freeNoteArr = [[NoteManager sharedInstance] notetableGetNotesWithPage:self.page NoteType:NoteTypeFree];
    if (self.lineArray.count == 0) {
        if (freeNoteArr.count) {
            NoteModel *note = freeNoteArr.firstObject;
            //存在 清除
//            [[NoteManager sharedInstance] notetableRemoveDataWithModel:note];
            NoteModel *m = [NoteExtraManager getNoteWithId:note.noteId type:NoteList_Local];
            [NoteExtraManager LocalNotesRemoveNote:m];
        }
    }else{
        
        NoteModel *note;
        if (!freeNoteArr.count) {
            //新增
            note = [[NoteModel alloc] init];
            note.noteId = [NSString stringWithFormat:@"%lld",self.modelID];
            note.page = self.page;
            note.noteType = NoteTypeFree;
            //                note.pageWidth = model.viewWidth;
            note.pageWidth = self.renderSize.width;
            note.pageHeight = self.renderSize.height;
            note.timeDate = [NSDate date];
            //            note.coord = coord;
            
            if([NoteExtraManager LocalNotesInsertNote:note]){
                
            } else {
                NSLog(@"笔记添加失败");
                return;
            }
            freeNoteArr = [[NoteManager sharedInstance] notetableGetNotesWithPage:self.page NoteType:NoteTypeFree];
            note = freeNoteArr.firstObject;
            note.isNewFree = YES;
            
        }else{
            note = freeNoteArr.firstObject;
            if ([[NoteManager sharedInstance] deleteLinesWithNoteId:note.noteId]) {
                NoteModel *md = [NoteExtraManager getNoteWithId:note.noteId type:NoteList_Local];
                [NoteExtraManager LocalNotesRemoveNote:md];
                NSLog(@"____老自由画笔删除成功");
            }
        }
        
        NSMutableArray *linArray = [NSMutableArray array];
        for (int i =0;i<self.lineArray.count;i++) {
            FreeCoord *fc = [[FreeCoord alloc] init];
            NSArray *line = self.lineArray[i];
            NSMutableArray *coordArray = [[NSMutableArray alloc] init];
            for (NSArray *points in line) {
                for (NSString *s in points) {
                    CGPoint p = CGPointFromString(s);
                    [coordArray addObject:[NSNumber numberWithFloat:p.x]];
                    [coordArray addObject:[NSNumber numberWithFloat:p.y]];
                }
            }
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:coordArray options:NSJSONWritingPrettyPrinted error:nil];
            fc.coord =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            UIColor *c = self.colorArray[i];
            LineColor lc = [[ConfigManager sharedInstance] getLineColorWithColor:c];
            fc.color = lc;
            NSNumber *num = self.lineWidthArray[i];
            FreeLine fl = [[ConfigManager sharedInstance] getFreeLineWithNum:num];
            fc.width = fl;
            fc.noteId = note.noteId;
            fc.md5 = [NetTools md5:fc.coord];
            [linArray addObject:fc];
        }
        
        if ([[NoteManager sharedInstance] freetableInsertLinesWithModelArry:linArray]) {
            if (!note.isNewFree) {
                [NoteExtraManager LocalNotesInsertNote:note];
            }
            
            NSLog(@"____更新自由画笔成功");
        }
        
        
    }
    
}
@end
