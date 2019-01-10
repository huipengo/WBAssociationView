//
//  WBAssociationItem.h
//
//  Created by penghui8 on 2018/12/10.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBAssociationItem : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *value;

@property (nonatomic, strong) NSArray<WBAssociationItem *> *s_items;

@property (nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, assign) NSInteger selected_count;

+ (NSArray<WBAssociationItem *> *)wb_itemsForKey:(NSString *)key;

/** 是否是"全部 item" */
- (BOOL)wb_isAll;

/** 点击 全部 item */
+ (void)wb_didSelectAll:(NSArray<WBAssociationItem *> *)items selected:(BOOL)selected;

/** 点击某一项，更新 "全部 item" */
+ (void)wb_updateSelectAllItem:(NSArray<WBAssociationItem *> *)items selected:(BOOL)selected;

/** all select items action */
+ (void)wb_allSelectItems:(NSArray<WBAssociationItem *> *)items selected:(BOOL)selected;

/** 是否全部已选择 */
+ (BOOL)wb_isAllSelectedItems:(NSArray<WBAssociationItem *> *)items;

/** update all items */
+ (void)wb_updateAllItems:(NSArray<WBAssociationItem *> *)items selected:(BOOL)selected;

+ (NSArray<WBAssociationItem *> *)wb_allSelectedItems:(NSArray<WBAssociationItem *> *)items;

@end

NS_ASSUME_NONNULL_END
