//
//  WBAssociationViewController.m
//
//  Created by penghui8 on 2018/12/7.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import "WBAssociationViewController.h"
#import "WBAssociationView.h"
#import "WBAssociationCell.h"
#import "WBAssociationItem.h"

#import "WBAssociationBottomView.h"
#import <Masonry.h>
#import "WBConfigure.h"
#import "UIColor+Ex.h"

static NSString * const wb_association_name  = @"name";
static NSString * const wb_association_value = @"value";

static CGFloat const wb_cell_row_height = 50.0f;

@interface WBAssociationViewController () <WBAssociationProtocol>

@property (nonatomic, strong) WBAssociationView *contentView;

@end

@implementation WBAssociationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)wb_viewConfigure {
    [super wb_viewConfigure];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view).with.offset(0.0f);
        make.top.equalTo(self.view).with.offset(wb_status_navBarHeight());
        make.bottom.equalTo(self.bottomView.mas_top).with.offset(-0.0f);
    }];
    
    [self wb_autoSelectedRow];
    [self.contentView wb_showAssociationView:nil];
}

- (void)wb_autoSelectedRow {
    NSInteger idx_0 = 0;
    NSInteger idx_1 = 0;
    NSInteger idx_2 = 0;
    
    NSInteger count_0 = [self wb_numberForLevel_0];
    NSInteger count_1 = -1;
    NSInteger count_2 = -1;
    
    if (count_0 > 0) {
        count_1 = [self wb_numberForLevel_1_didSelectRowInLevel_0:idx_0];
        if (count_1 > 0) {
            count_2 = [self wb_numberForLevel_2_didSelectRowInLevel_0:idx_0 level_1:idx_1];
        }
    }
    
    [self.contentView wb_selectedIndexForLevel_0:(count_0 > 0) ? idx_0 : -1
                                         level_1:(count_1 > 0) ? idx_1 : -1
                                         level_2:(count_2 > 0) ? idx_2 : -1];
}

#pragma mark -- WBAssociationProtocol
- (NSArray<UITableView *> *)wb_tableViews {
    return @[[self.class tableView], [self.class tableView], [self.class tableView]];
}

+ (UITableView *)tableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor wb_grayColor_Bg];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorColor = [UIColor wb_lineColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.rowHeight = wb_cell_row_height;
    return tableView;
}

- (UITableViewCell *)wb_tableViewForLevel_0:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WBAssociationCell *cell = [WBAssociationCell wb_cellNibForTableView:tableView];
    WBAssociationItem *item = [self objectInLevel_0:indexPath.row];
    [cell setItem:item];
    return cell;
}

- (UITableViewCell *)wb_tableViewForLevel_1:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath didSelectRowInLevel_0:(NSInteger)idx_0 {
    WBAssociationCell *cell   = [WBAssociationCell wb_cellNibForTableView:tableView];
    WBAssociationItem *s_item = [self objectInLevel_1:indexPath.row level_0:idx_0];
    [cell setItem:s_item];
    return cell;
}

- (UITableViewCell *)wb_tableViewForLevel_2:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath didSelectRowInLevel_0:(NSInteger)idx_0 level_1:(NSInteger)idx_1 {
    WBAssociationCell *cell    = [WBAssociationCell wb_cellNibForTableView:tableView];
    WBAssociationItem *ss_item = [self objectInLevel_2:indexPath.row level_1:idx_1 level_0:idx_0];
    [cell setItem:ss_item];
    return cell;
}

- (NSInteger)wb_numberForLevel_2_didSelectRowInLevel_0:(NSInteger)idx_0 level_1:(NSInteger)idx_1 {
    WBAssociationItem *s_item = [self objectInLevel_1:idx_1 level_0:idx_0];
    return s_item.s_items.count;
}

- (NSInteger)wb_numberForLevel_1_didSelectRowInLevel_0:(NSInteger)idx_0 {
    WBAssociationItem *item = [self objectInLevel_0:idx_0];
    return item.s_items.count;
}

- (NSInteger)wb_numberForLevel_0 {
    return self.dataSource.count;
}

- (BOOL)wb_tableView:(UITableView *)tableView didSelectRowInLevel_0:(NSInteger)idx_0 {
    WBAssociationItem *item = [self objectInLevel_0:idx_0];
    if (item.s_items.count <= 0) {
        item.selected = !item.selected;
        [self wb_updateBottomView];
        return NO;
    }
    return YES;
}

- (BOOL)wb_tableView:(UITableView *)tableView didSelectRowInLevel_0:(NSInteger)idx_0 level_1:(NSInteger)idx_1 {
    WBAssociationItem *s_item = [self objectInLevel_1:idx_1 level_0:idx_0];
    if (s_item.s_items.count <= 0) {
        s_item.selected = !s_item.isSelected;
        WBAssociationItem *item = [self objectInLevel_0:idx_0];
        if (s_item.wb_isAll) {
            [WBAssociationItem wb_didSelectAll:item.s_items selected:s_item.isSelected];
        }
        else {
            [WBAssociationItem wb_updateSelectAllItem:item.s_items selected:s_item.isSelected];
        }
        
        [self wb_updateBottomView];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)wb_tableView:(UITableView *)tableView didSelectRowInLevel_0:(NSInteger)idx_0 level_1:(NSInteger)idx_1 level_2:(NSInteger)idx_2 {
    WBAssociationItem *ss_item = [self objectInLevel_2:idx_2 level_1:idx_1 level_0:idx_0];
    if (ss_item.s_items.count <= 0) {
        ss_item.selected = !ss_item.isSelected;
        WBAssociationItem *s_item = [self objectInLevel_1:idx_1 level_0:idx_0];
        if (ss_item.wb_isAll) {
            [WBAssociationItem wb_didSelectAll:s_item.s_items selected:ss_item.isSelected];
        }
        else {
            [WBAssociationItem wb_updateSelectAllItem:s_item.s_items selected:ss_item.isSelected];
        }
        
        s_item.selected = (s_item.selected_count > 0);
        WBAssociationItem *item = [self objectInLevel_0:idx_0];
        [WBAssociationItem wb_updateSelectAllItem:item.s_items selected:s_item.isSelected];
        
        [self wb_updateBottomView];
        
        return NO;
    }
    return YES;
}

- (WBAssociationItem *)objectInLevel_0:(NSInteger)idx_1 {
    WBAssociationItem *item = [self.dataSource objectAtIndex:idx_1];
    return item;
}

- (WBAssociationItem *)objectInLevel_1:(NSInteger)idx_1 level_0:(NSInteger)idx_0 {
    WBAssociationItem *item = [self objectInLevel_0:idx_0];
    if (idx_1 >= 0) {
        WBAssociationItem *s_item = [item.s_items objectAtIndex:idx_1];
        return s_item;
    }
    return item;
}

- (WBAssociationItem *)objectInLevel_2:(NSInteger)idx_2 level_1:(NSInteger)idx_1 level_0:(NSInteger)idx_0 {
    WBAssociationItem *s_item  = [self objectInLevel_1:idx_1 level_0:idx_0];
    if (idx_2 >= 0) {
        WBAssociationItem *ss_item = [s_item.s_items objectAtIndex:idx_2];
        return ss_item;
    }
    return s_item;
}

#pragma mark -- getter method
- (WBAssociationView *)contentView {
    if (!_contentView) {
        _contentView = ({
            WBAssociationView *view = [[WBAssociationView alloc] initWithFrame:CGRectZero];
            view.delegate = self;
            view;
        });
    }
    return _contentView;
}

@end
