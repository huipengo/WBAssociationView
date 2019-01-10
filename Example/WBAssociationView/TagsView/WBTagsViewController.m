//
//  WBTagsViewController.m
//
//  Created by penghui8 on 2019/1/9.
//  Copyright © 2019 penghui8. All rights reserved.
//

#import "WBTagsViewController.h"
#import <Masonry.h>
#import <FMTagsView.h>
#import "UIColor+Ex.h"

@interface WBTagsViewController () <FMTagsViewDelegate>

@property (nonatomic, strong) FMTagsView *tagsView;

@end

@implementation WBTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self wb_loadData:self.dataSource];
}

- (void)wb_viewConfigure {
    [super wb_viewConfigure];
    [self.view addSubview:self.tagsView];
    
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).with.offset(0.0f);
        make.trailing.equalTo(self.view).with.offset(0.0f);
        make.top.equalTo(self.view).with.offset(0.0f);
        make.bottom.equalTo(self.bottomView.mas_top).with.offset(0.0f);
    }];
}

- (void)wb_loadData:(NSArray<WBAssociationItem *> *)items {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:items.count];
    [items enumerateObjectsUsingBlock:^(WBAssociationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj.name];
    }];
    self.tagsView.tagsArray = array;
}

#pragma mark --
- (void)wb_allItemSelected:(BOOL)selected {
    if (selected) {
        [self.dataSource enumerateObjectsUsingBlock:^(WBAssociationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tagsView selectTagAtIndex:idx animate:YES];
        }];
    }
    else {
        [self.tagsView deSelectAll];
    }
}

- (void)wb_deletedItem:(WBAssociationItem *)item {
    NSInteger index = [self.dataSource indexOfObject:item];
    [self.tagsView deSelectTagAtIndex:index animate:YES];
}

- (void)wb_clearAllItem {
    [self.tagsView deSelectAll];
}

#pragma mark --
- (void)tagsView:(FMTagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index {
    [self wb_updateTagAtIndex:index selected:YES];
}

- (void)tagsView:(FMTagsView *)tagsView didDeSelectTagAtIndex:(NSUInteger)index {
    [self wb_updateTagAtIndex:index selected:NO];
}

- (void)wb_updateTagAtIndex:(NSInteger)index selected:(BOOL)selected {
    WBAssociationItem *item = [self.dataSource objectAtIndex:index];
    item.selected = selected;
    
    [self wb_updateBottomView];
}

#pragma mark --
- (FMTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[FMTagsView alloc] initWithFrame:CGRectZero];
        _tagsView.tagBackgroundColor = [UIColor clearColor];
        _tagsView.tagBorderColor = [UIColor wb_borderColor];
        _tagsView.tagBorderWidth = (1.0f / [UIScreen mainScreen].scale) * 2;
        _tagsView.tagcornerRadius = 2.0f;
        _tagsView.allowEmptySelection = YES;
        _tagsView.allowsSelection = YES;
        _tagsView.allowsMultipleSelection = YES;
        _tagsView.contentInsets = UIEdgeInsetsMake(15.0f, 15.0f, 20.0f, 15.0f);
        _tagsView.lineSpacing = 12.0f;
        _tagsView.interitemSpacing = 15.0f;
        _tagsView.tagInsets = UIEdgeInsetsMake(5.0f, 20.0f, 5.0f, 20.0f);
        _tagsView.delegate = self;
    }
    return _tagsView;
}

@end
