//
//  UIImage+Ex.m
//  WBKit
//
//  Created by huipeng on 2018/1/8.
//  Copyright © 2018年 penghui8. All rights reserved.
//

#import "UIImage+Ex.h"

@implementation UIImage (Ex)

+ (UIImage *)imageWithSolidColor:(UIColor *)color size:(CGSize)size {
    NSParameterAssert(color);
    NSAssert(!CGSizeEqualToSize(size, CGSizeZero), @"Size cannot be CGSizeZero");
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    // Create a context depending on given size
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    
    // Fill it with your color
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
