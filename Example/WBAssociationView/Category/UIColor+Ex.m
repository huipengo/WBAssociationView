//
//  UIColor+Ex.m
//  WBAssociationView_Example
//
//  Created by penghui8 on 2019/1/9.
//  Copyright © 2019 penghui8. All rights reserved.
//

#import "UIColor+Ex.h"

UIColor *UIColorWithRGBA(NSUInteger rgb, CGFloat alpha) {
    UIColor *normalColor = [UIColor colorWithRed:((float)((rgb & 0xFF0000) >> 16))/255.0 green:((float)((rgb & 0xFF00) >> 8))/255.0 blue:((float)(rgb & 0xFF))/255.0 alpha:alpha];
    return normalColor;
}

UIColor *UIColorWithRGB(NSUInteger rgb) {
    return UIColorWithRGBA(rgb, 1.0f);
}

@implementation UIColor (Ex)

+ (UIColor *)wb_titleColor
{
    return UIColorWithRGB(0x363636);
}

+ (UIColor *)wb_blackColor
{
    return UIColorWithRGB(0x172434);
}

+ (UIColor *)wb_grayColor
{
    return UIColorWithRGB(0x8E9091);
}

+ (UIColor *)wb_lightGrayColor
{
    return UIColorWithRGB(0x999999);
}

+ (UIColor *)wb_grayColor_Bg
{
    return UIColorWithRGB(0xEFEFF4);
}

+ (UIColor *)wb_grayColor_H
{
    return UIColorWithRGB(0xECECEC);
}

+ (UIColor *)wb_blueColor
{
    return UIColorWithRGB(0x3352FE);
}

+ (UIColor *)wb_blueColor_H
{
    return UIColorWithRGB(0x3333FF);
}

+ (UIColor *)wb_lineColor {
    return UIColorWithRGB(0xDCE2EA);
}

+ (UIColor *)wb_borderColor {
    return UIColorWithRGB(0xE4E8F2);
}

@end
