//
//  NSString+FGString.m
//  Reader_SH appstore
//
//  Created by 王放歌 on 2018/8/28.
//  Copyright © 2018年 Sumtice. All rights reserved.
//

#import "NSString+FGString.h"
#import <objc/message.h>
@implementation NSString (FGString)

+ (void)load{
    
    
    [[NSString alloc] swizzleInstanceMethod:@selector(initWithString:) withMethod:@selector(FG_InitWithString:)];
    [[[NSString alloc]init] swizzleInstanceMethod:@selector(stringByAppendingString:) withMethod:@selector(FG_stringByAppendingString:)];
}

+ (void)swizzleClassMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getClassMethod(class, origSelector);
    Method swizzledMethod = class_getClassMethod(class, newSelector);
    
    Class metacls = objc_getMetaClass(NSStringFromClass(class).UTF8String);
    if (class_addMethod(metacls,
                        origSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /* swizzing super class method, added if not exist */
        class_replaceMethod(metacls,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (void)swizzleInstanceMethod:(SEL)origSelector withMethod:(SEL)newSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    if (class_addMethod(class,
                        origSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod)) ) {
        /*swizzing super class instance method, added if not exist */
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (instancetype)FG_InitWithString:(NSString *)aString{
    if (aString == nil) {
        return @"";
    }else{
        return [[NSString alloc] FG_InitWithString:aString];
        
    }
    
}
- (NSString *)FG_stringByAppendingString:(NSString *)aString{
    if (aString == nil) {
        return self;
    }else{
        return [self FG_stringByAppendingString:aString];
    }
}


@end
