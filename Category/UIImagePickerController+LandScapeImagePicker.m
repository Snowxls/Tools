//
//  UIImagePickerController+LandScapeImagePicker.m
//  PDFReader
//
//  Created by 王放歌 on 2018/12/12.
//  Copyright © 2018年 com.chineseall.www. All rights reserved.
//

#import "UIImagePickerController+LandScapeImagePicker.h"

@implementation UIImagePickerController (LandScapeImagePicker)
-(BOOL)shouldAutorotate{
    return YES;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
@end
