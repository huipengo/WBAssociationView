//
//  UIColor+Ex.h
//  WBAssociationView_Example
//
//  Created by penghui8 on 2019/1/9.
//  Copyright © 2019 penghui8. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Ex)

/// 标题黑色
+ (UIColor *)wb_titleColor;

/// 黑色(标题)
+ (UIColor *)wb_blackColor;

/// 内容(灰色)
+ (UIColor *)wb_grayColor;

/// 内容(淡灰色)
+ (UIColor *)wb_lightGrayColor;

/// 背景灰色
+ (UIColor *)wb_grayColor_Bg;

/// 按下灰色(cell点击效果)
+ (UIColor *)wb_grayColor_H;

/// 蓝色
+ (UIColor *)wb_blueColor;

/// 蓝色高亮
+ (UIColor *)wb_blueColor_H;

+ (UIColor *)wb_lineColor;

+ (UIColor *)wb_borderColor;

@end

NS_ASSUME_NONNULL_END
