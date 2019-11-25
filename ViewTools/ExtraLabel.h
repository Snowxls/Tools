//
//  ExtraLabel.h
//  PDFReader
//
//  Created by Snow WarLock on 2019/5/21.
//  Copyright © 2019 com.chineseall.www. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, VerticalAlignment) {
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
};

@interface ExtraLabel : UILabel

{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic,readwrite) VerticalAlignment verticalAlignment;

@end

NS_ASSUME_NONNULL_END
