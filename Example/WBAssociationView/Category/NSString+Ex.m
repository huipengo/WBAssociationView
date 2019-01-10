//
//  NSString+Ex.m
//  WBAssociationView_Example
//
//  Created by penghui8 on 2019/1/9.
//  Copyright © 2019 penghui8. All rights reserved.
//

#import "NSString+Ex.h"

@implementation NSString (Ex)

- (CGSize)sizeWithBoundingRectSize:(CGSize)rectSize attributeFont:(UIFont *)attributeFont {
    
    if (!([self isKindOfClass:[NSString class]] && self.length > 0)) {
        return CGSizeZero;
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: attributeFont};
    
    CGSize stringSize = [self boundingRectWithSize:rectSize
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                        attributes:attributes
                                           context:nil].size;
    
    return CGSizeMake(ceilf(stringSize.width), ceilf(stringSize.height));
}

@end
