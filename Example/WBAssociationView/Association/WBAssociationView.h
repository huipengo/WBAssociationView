//
//  WBAssociationView.h
//
//  Created by penghui8 on 2018/12/7.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBAssociationProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBAssociationView : UIView

@property (nonatomic, weak) id<WBAssociationProtocol> delegate;

/**
 *  设置选中项，-1 为未选中
 *
 *  @param idx_0  第一级选中项
 *  @param idx_1  第二级选中项
 *  @param idx_2  第三级选中项
 */
- (void)wb_selectedIndexForLevel_0:(NSInteger)idx_0 level_1:(NSInteger)idx_1 level_2:(NSInteger)idx_2;

/**
 *  菜单显示在View的下面
 *
 *  @param view 显示在该view下
 */
- (void)wb_showAssociationView:(UIView * _Nullable)view;

/**
 *  隐藏菜单
 */
- (void)wb_dismissView;

@end

NS_ASSUME_NONNULL_END
