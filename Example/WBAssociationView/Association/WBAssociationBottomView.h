//
//  WBAssociationBottomView.h
//
//  Created by penghui8 on 2018/12/13.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBAssociationItem.h"

FOUNDATION_EXPORT CGFloat const wb_bottom_view_height;

@class WBAssociationBottomView;
@protocol WBAssociationBottomProtocol <NSObject>

@optional
- (void)wb_bottomView:(WBAssociationBottomView *)bottomView doneAction:(UIButton *)sender;

- (void)wb_bottomView:(WBAssociationBottomView *)bottomView selectedAction:(UIButton *)sender;

- (void)wb_bottomView:(WBAssociationBottomView *)bottomView allSelectAction:(UIButton *)sender;

- (void)wb_bottomView:(WBAssociationBottomView *)bottomView deletedAction:(WBAssociationItem *)item;

- (void)wb_bottomView_clearTrashAction:(WBAssociationBottomView *)bottomView;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WBAssociationBottomView : UIView

@property (nonatomic, weak) id<WBAssociationBottomProtocol> delegate;

+ (instancetype)viewWithOwner:(id)owner;

- (void)wb_updateAllSelectState:(BOOL)isAllSelect;

- (void)wb_updateSelectedItems:(NSArray<WBAssociationItem *> *)items;

- (void)wb_updateSelectedCount:(NSInteger)selectedCount;

@end

NS_ASSUME_NONNULL_END
