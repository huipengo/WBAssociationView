//
//  WBBottomViewController.m
//
//  Created by penghui8 on 2019/1/9.
//  Copyright © 2019 penghui8. All rights reserved.
//

#import "WBBottomViewController.h"
#import <Masonry.h>
#import "WBConfigure.h"

@interface WBBottomViewController () <WBAssociationBottomProtocol>

@property (nonatomic, strong, readwrite) WBAssociationBottomView *bottomView;

@property (nonatomic, strong, readwrite) NSArray<WBAssociationItem *> *dataSource;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, strong) NSMutableArray<WBAssociationItem *> *selectedValues;

@end

@implementation WBBottomViewController

+ (instancetype)viewControllerWithKey:(NSString *)key {
    WBBottomViewController *viewController = [[self.class alloc] init];
    viewController.key = key;
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self wb_viewConfigure];
}

- (void)wb_viewConfigure {
    [self.view addSubview:self.bottomView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view).with.offset(0.0f);
        make.height.mas_equalTo(@(wb_bottom_view_height + wb_safeBottomMargin()));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-0.0f);
    }];
}

#pragma mark -- WBAssociationBottomProtocol
- (void)wb_bottomView:(WBAssociationBottomView *)bottomView doneAction:(UIButton *)sender {
    BOOL isAllSelected = [WBAssociationItem wb_isAllSelectedItems:self.dataSource];
    if (isAllSelected) {
        /** 不限 */
    }
    else {
        NSArray<WBAssociationItem *> *array = [WBAssociationItem wb_allSelectedItems:self.dataSource];
        [self wb_updateSuperItems:array];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)wb_bottomView:(WBAssociationBottomView *)bottomView selectedAction:(UIButton *)sender {
    
}

- (void)wb_bottomView:(WBAssociationBottomView *)bottomView allSelectAction:(UIButton *)sender {
    BOOL selected = sender.selected;
    
    [WBAssociationItem wb_allSelectItems:self.dataSource selected:selected];
    [self wb_updateSelectedItems];
    
    [self wb_allItemSelected:selected];
}

- (void)wb_bottomView:(WBAssociationBottomView *)bottomView deletedAction:(WBAssociationItem *)item {
    [self wb_updateSelectedCount];
    [self wb_updateAllSelectState];
    
    [self wb_deletedItem:item];
}

- (void)wb_bottomView_clearTrashAction:(WBAssociationBottomView *)bottomView {
    [WBAssociationItem wb_updateAllItems:self.dataSource
                                selected:NO];
    [self wb_updateBottomView];
    
    [self wb_clearAllItem];
}

#pragma mark -- custom
- (void)wb_allItemSelected:(BOOL)selected {
    
}

- (void)wb_deletedItem:(WBAssociationItem *)item {
    
}

- (void)wb_clearAllItem {
    
}

#pragma mark -- update bottom
- (void)wb_updateBottomView {
    [self wb_updateSelectedItems];
    [self wb_updateAllSelectState];
}

- (void)wb_updateAllSelectState {
    BOOL isAllSelected = [WBAssociationItem wb_isAllSelectedItems:self.dataSource];
    [self.bottomView wb_updateAllSelectState:isAllSelected];
}

- (void)wb_updateSelectedItems {
    NSArray<WBAssociationItem *> *array = [WBAssociationItem wb_allSelectedItems:self.dataSource];
    [self.bottomView wb_updateSelectedItems:array];
}

- (void)wb_updateSelectedCount {
    NSArray *array = [WBAssociationItem wb_allSelectedItems:self.dataSource];
    [self.bottomView wb_updateSelectedCount:array.count];
}

- (void)wb_updateSuperItems:(NSArray<WBAssociationItem *> *)items {
    NSMutableArray *contents = [NSMutableArray arrayWithCapacity:items.count];
    [items enumerateObjectsUsingBlock:^(WBAssociationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [contents addObject:obj.name];
    }];
    NSLog(@"%@", [contents componentsJoinedByString:@"、"]);
}

#pragma mark -- getter
- (WBAssociationBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = ({
            WBAssociationBottomView *view = [WBAssociationBottomView viewWithOwner:self];
            view.delegate = self;
            view;
        });
    }
    return _bottomView;
}

- (NSArray<WBAssociationItem *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [WBAssociationItem wb_itemsForKey:self.key];
    }
    return _dataSource;
}

- (NSMutableArray<__kindof WBAssociationItem *> *)selectedValues {
    if (!_selectedValues) {
        _selectedValues = [NSMutableArray array];
    }
    return _selectedValues;
}

@end
