//
//  UIButton+Ex.m
//  WBKit
//
//  Created by huipeng on 2018/1/17.
//  Copyright © 2018年 penghui8. All rights reserved.
//

#import "UIButton+Ex.h"
#import "UIImage+Ex.h"

@implementation UIButton (Ex)

- (void)setBackgroundColor:(nullable UIColor *)color forState:(UIControlState)state {
    UIImage *image = [UIImage imageWithSolidColor:color size:self.frame.size];
    [self setBackgroundImage:image forState:state];
}

@end
