//
//  WBAssociationProtocol.h
//
//  Created by penghui8 on 2018/12/7.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WBAssociationView;

NS_ASSUME_NONNULL_BEGIN

@protocol WBAssociationProtocol <NSObject>

- (NSArray<UITableView *> *)wb_tableViews;

- (UITableViewCell *)wb_tableViewForLevel_0:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)wb_tableViewForLevel_1:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath didSelectRowInLevel_0:(NSInteger)idx_0;

- (UITableViewCell *)wb_tableViewForLevel_2:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath didSelectRowInLevel_0:(NSInteger)idx_0 level_1:(NSInteger)idx_1;

/**
 *  获取第 Level 级菜单的数据数量
 *
 *  @param idx_0  选中的第一级菜单
 *  @param idx_1  选中的第二级菜单
 *
 *  @return 第 Level 级菜单的数据数量
 */
- (NSInteger)wb_numberForLevel_2_didSelectRowInLevel_0:(NSInteger)idx_0 level_1:(NSInteger)idx_1;

- (NSInteger)wb_numberForLevel_1_didSelectRowInLevel_0:(NSInteger)idx_0;

- (NSInteger)wb_numberForLevel_0;

@optional
- (void)wb_associationView_dismiss;

/**
 *  选择第一级菜单
 *
 *  @param idx_0  第一级
 *
 *  @return 是否展示下一级
 */
- (BOOL)wb_tableView:(UITableView *)tableView didSelectRowInLevel_0:(NSInteger)idx_0;

/**
 *  选择第二级菜单
 *
 *  @param idx_0  第一级
 *  @param idx_1  第二级
 *
 *  @return 是否展示下一级
 */
- (BOOL)wb_tableView:(UITableView *)tableView didSelectRowInLevel_0:(NSInteger)idx_0 level_1:(NSInteger)idx_1;

/**
 *  选择第三级菜单
 *
 *  @param idx_0  第一级
 *  @param idx_1  第二级
 *  @param idx_2  第三级
 *
 *  @return 是否dismiss
 */
- (BOOL)wb_tableView:(UITableView *)tableView didSelectRowInLevel_0:(NSInteger)idx_0 level_1:(NSInteger)idx_1 level_2:(NSInteger)idx_2;

@end

NS_ASSUME_NONNULL_END
