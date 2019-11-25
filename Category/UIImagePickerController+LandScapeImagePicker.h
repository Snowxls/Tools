//
//  UIImagePickerController+LandScapeImagePicker.h
//  PDFReader
//
//  Created by 王放歌 on 2018/12/12.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImagePickerController (LandScapeImagePicker)
- (BOOL)shouldAutorotate;
- (NSUInteger)supportedInterfaceOrientations;
@end

