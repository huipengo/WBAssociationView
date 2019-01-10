//
//  WBAssociationSelectedView.m
//
//  Created by penghui8 on 2018/12/25.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import "WBAssociationSelectedView.h"
#import "WBAssociationSelectedHeaderView.h"
#import <Masonry.h>
#import <FMTagsView.h>
#import "UIColor+Ex.h"

static CGFloat const wb_headerView_height = 40.0f;

@interface WBAssociationSelectedView () <FMTagsViewDelegate>

@property (nonatomic, strong) WBAssociationSelectedHeaderView *headerView;

@property (nonatomic, strong) FMTagsView *tagsView;

@end

@implementation WBAssociationSelectedView

+ (instancetype)viewWithFrame:(CGRect)frame {
    WBAssociationSelectedView *view = [[WBAssociationSelectedView alloc] initWithFrame:frame];
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self wb_viewConfigure];
    }
    return self;
}

- (void)wb_viewConfigure {
    [self addSubview:self.headerView];
    [self addSubview:self.tagsView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).with.offset(0.0f);
        make.trailing.equalTo(self).with.offset(0.0f);
        make.top.equalTo(self).with.offset(0.0f);
        make.height.mas_equalTo(@(wb_headerView_height));
    }];
    
    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).with.offset(0.0f);
        make.trailing.equalTo(self).with.offset(0.0f);
        make.top.equalTo(self.headerView.mas_bottom).with.offset(0.0f);
        make.bottom.equalTo(self.mas_bottom).with.offset(-0.0f);
    }];
}

- (void)wb_loadData:(NSArray<WBAssociationItem *> *)items {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:items.count];
    [items enumerateObjectsUsingBlock:^(WBAssociationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:obj.name];
    }];
    self.tagsView.tagsArray = array;
}

- (CGFloat)wb_viewHeight {
    NSInteger count = self.tagsView.tagsArray.count;
    UIEdgeInsets insets = self.tagsView.contentInsets;
    CGFloat height = wb_headerView_height + insets.top + insets.bottom;
    NSInteger line_count = ((count / 3) + ((count % 3) != 0));
    height += (line_count * self.tagsView.tagHeight) + (line_count - 1) * self.tagsView.lineSpacing;
    return height;
}

#pragma mark --
- (WBAssociationSelectedHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [WBAssociationSelectedHeaderView viewWithOwner:self];
        __weak typeof(self) weakSelf = self;
        _headerView.clearTrashCompletion = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            !strongSelf.clearTrashCompletion ?: strongSelf.clearTrashCompletion();
        };
    }
    return _headerView;
}

- (FMTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[FMTagsView alloc] initWithFrame:CGRectZero];
        _tagsView.tagBackgroundColor = [UIColor clearColor];
        _tagsView.tagBorderColor = [UIColor wb_borderColor];
        _tagsView.tagBorderWidth = 0.5 * 2;
        _tagsView.tagcornerRadius = 2.0f;
        _tagsView.allowEmptySelection = NO;
        _tagsView.allowsSelection = NO;
        _tagsView.contentInsets = UIEdgeInsetsMake(15.0f, 15.0f, 20.0f, 15.0f);
        _tagsView.lineSpacing = 12.0f;
        _tagsView.interitemSpacing = 15.0f;
        _tagsView.tagInsets = UIEdgeInsetsMake(5.0f, 28.0f, 5.0f, 28.0f);
        _tagsView.suffix_image = [UIImage imageNamed:@"wb_tag_delete"];
        _tagsView.delegate = self;
    }
    return _tagsView;
}

#pragma mark --
- (void)tagsView:(FMTagsView *)tagsView imageTagAtIndex:(NSUInteger)index {
    !self.deletedCompletion ?: self.deletedCompletion(index);
}

@end
