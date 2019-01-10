//
//  WBAssociationItem.m
//
//  Created by penghui8 on 2018/12/10.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import "WBAssociationItem.h"

static NSString * const wb_association_name  = @"name";
static NSString * const wb_association_value = @"value";

static NSString * const wb_association_all   = @"wb_all";

@implementation WBAssociationItem

+ (NSArray<WBAssociationItem *> *)wb_itemsForKey:(NSString *)key {
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"wb_plan_data" ofType:@"plist"];
    NSDictionary *info  = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray<NSDictionary *> *array = [info objectForKey:key];
    
    NSArray<WBAssociationItem *> *items = [self wb_associationItems:array];
    return items;
}

+ (NSArray<WBAssociationItem *> *)wb_associationItems:(NSArray<NSDictionary *> *)values {
    NSMutableArray<WBAssociationItem *> *w_items = [NSMutableArray array];
    [values enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        WBAssociationItem *_item = [[WBAssociationItem alloc] init];
        NSString *name = [obj objectForKey:wb_association_name];
        id value       = [obj objectForKey:wb_association_value];
        _item.name = name;
        if ([value isKindOfClass:NSArray.class]) {
            NSMutableArray<WBAssociationItem *> *s_items = [NSMutableArray array];
            WBAssociationItem *all_item = self.wb_allItem;
            [s_items addObject:all_item];
            NSArray<WBAssociationItem *> *s_value = [self wb_associationItems:value];
            [s_items addObjectsFromArray:s_value];
            _item.s_items = s_items;
        }
        else if ([value isKindOfClass:NSNumber.class] ||
                 [value isKindOfClass:NSString.class]) {
            _item.value = [NSString stringWithFormat:@"%@", value];
        }
        
        [w_items addObject:_item];
    }];
    return w_items;
}

+ (WBAssociationItem *)wb_allItem {
    WBAssociationItem *item = [[WBAssociationItem alloc] init];
    item.name  = @"全部";
    item.value = wb_association_all;
    return item;
}

- (NSInteger)selected_count {
    NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"(selected == YES) && (value != %@)", wb_association_all];
    NSArray *selected_items  = [self.s_items filteredArrayUsingPredicate:predicate];
    NSInteger selected_count = selected_items.count;
    return selected_count;
}

- (BOOL)wb_isAll {
    return [self.value isEqualToString:wb_association_all];
}

+ (void)wb_didSelectAll:(NSArray<WBAssociationItem *> *)items selected:(BOOL)selected {
    NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"(selected == %@)", @(!selected)];
    NSArray *selected_items  = [items filteredArrayUsingPredicate:predicate];
    [selected_items enumerateObjectsUsingBlock:^(WBAssociationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = selected;
        if (obj.s_items.count > 0) {
            [self wb_didSelectAll:obj.s_items selected:obj.isSelected];
        }
    }];
}

+ (void)wb_updateSelectAllItem:(NSArray<WBAssociationItem *> *)items selected:(BOOL)selected {
    WBAssociationItem *s_all_item = [items firstObject];
    if (s_all_item.wb_isAll) {
        if (selected) {
            NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"(selected == %@) && (value != %@)", @(selected), wb_association_all];
            NSArray *selected_items  = [items filteredArrayUsingPredicate:predicate];
            s_all_item.selected = (selected_items.count == (items.count - 1));
        }
        else {
            s_all_item.selected = NO;
        }
    }
}

+ (void)wb_updateAllItems:(NSArray<WBAssociationItem *> *)items selected:(BOOL)selected {
    //NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"(selected == %@)", @(!selected)];
    //NSArray *selected_items  = [items filteredArrayUsingPredicate:predicate];
    [items enumerateObjectsUsingBlock:^(WBAssociationItem *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.s_items.count > 0) {
            [self wb_updateAllItems:obj.s_items selected:selected];
        }
        obj.selected = selected;
    }];
}

+ (void)wb_allSelectItems:(NSArray<WBAssociationItem *> *)items selected:(BOOL)selected {
    [items enumerateObjectsUsingBlock:^(WBAssociationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isSelected != selected) {
            obj.selected = selected;
        }
        if (obj.s_items.count > 0) {
            [self wb_allSelectItems:obj.s_items selected:selected];
        }
    }];
}

+ (BOOL)wb_isAllSelectedItems:(NSArray<WBAssociationItem *> *)items {
    __block BOOL isAllSelected = YES;
    [items enumerateObjectsUsingBlock:^(WBAssociationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.s_items.count > 0) {
            isAllSelected = [self wb_isAllSelectedItems:obj.s_items];
            if (!isAllSelected) {
                *stop = YES;
            }
        }
        else {
            if ((!obj.isSelected) && (!obj.wb_isAll)) {
                isAllSelected = NO;
                *stop = YES;
            }
        }
    }];
    
    return isAllSelected;
}

+ (NSArray<WBAssociationItem *> *)wb_allSelectedItems:(NSArray<WBAssociationItem *> *)items {
    NSMutableArray<WBAssociationItem *> *selected_items = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(WBAssociationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.s_items.count > 0) {
            [selected_items addObjectsFromArray:[self wb_allSelectedItems:obj.s_items]];
        }
        else {
            if (obj.isSelected && (!obj.wb_isAll)) {
                [selected_items addObject:obj];
            }
        }
    }];
    
    return selected_items;
}

@end
