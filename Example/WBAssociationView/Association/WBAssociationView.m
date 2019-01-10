//
//  WBAssociationView.m
//
//  Created by penghui8 on 2018/12/7.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import "WBAssociationView.h"
#import "UIColor+Ex.h"

@interface WBAssociationView () <UITableViewDataSource, UITableViewDelegate> {
@private
    NSInteger _selectedIndexs[3];
}

@property (nonatomic, strong) NSArray<UITableView *> *tables;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation WBAssociationView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self wb_viewConfigure];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self wb_viewConfigure];
}

- (void)wb_viewConfigure {
    for (NSInteger i = 0; i != 3; ++i) {
        _selectedIndexs[i] = -1;
    }
    
    self.userInteractionEnabled = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    [self adjustTableViews];
}

- (NSArray<UITableView *> *)tables {
    if (!_tables) {
        if ([self.delegate respondsToSelector:@selector(wb_tableViews)]) {
            _tables = [self.delegate wb_tableViews];
        }
        
        [_tables enumerateObjectsUsingBlock:^(UITableView *table, NSUInteger idx, BOOL *stop) {
            table.dataSource = self;
            table.delegate = self;
            table.frame = CGRectZero;
        }];
    }
    return _tables;
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor wb_grayColor_Bg];
        _bgView.userInteractionEnabled = YES;
        [_bgView addSubview:[self.tables objectAtIndex:0]];
    }
    return _bgView;
}

#pragma mark -- private
- (void)adjustTableViews {
    NSInteger __block showTableCount = 0;
    [self.tables enumerateObjectsUsingBlock:^(UITableView *tableView, NSUInteger idx, BOOL *stop) {
        CGRect rect = tableView.frame;
        rect.size.height = self.frame.size.height - self.bgView.frame.origin.y;
        tableView.frame = rect;
        if (tableView.superview) {
            ++showTableCount;
        }
    }];
    
    CGFloat width = self.frame.size.width;
    for (NSInteger i = 0; i != showTableCount; ++i) {
        UITableView *tableView = [self.tables objectAtIndex:i];
        CGRect rect = tableView.frame;
        rect.size.width = width / showTableCount;
        rect.origin.x = rect.size.width * i;
        tableView.frame = rect;
    }
}

/**
 *  保存table选中项
 */
- (void)saveSelectedIndexs {
    [self.tables enumerateObjectsUsingBlock:^(UITableView *t, NSUInteger idx, BOOL *stop) {
        self->_selectedIndexs[idx] = t.superview ? t.indexPathForSelectedRow.row : -1;
    }];
}

/**
 *  加载保存的选中项
 */
- (void)loadSelectedIndexs {
    [self.tables enumerateObjectsUsingBlock:^(UITableView *t, NSUInteger i, BOOL *stop) {
        [t selectRowAtIndexPath:[NSIndexPath indexPathForRow:self->_selectedIndexs[i] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        if((self->_selectedIndexs[i] != -1 && !t.superview) || !i) {
            [self.bgView addSubview:t];
        }
    }];
}

#pragma mark - public
- (void)wb_selectedIndexForLevel_0:(NSInteger)idx_0 level_1:(NSInteger)idx_1 level_2:(NSInteger)idx_2 {
    self->_selectedIndexs[0] = idx_0;
    self->_selectedIndexs[1] = idx_1;
    self->_selectedIndexs[2] = idx_2;
}

- (void)wb_showAssociationView:(UIView * _Nullable)view {
    CGRect showFrame = view.frame;
    CGFloat x = 0.0f;
    CGFloat y = showFrame.origin.y + showFrame.size.height;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = self.frame.size.height - y;
    
    self.bgView.frame = CGRectMake(x, y, w, h);
    if (!self.bgView.superview) {
        [self addSubview:self.bgView];
    }
    
    [self loadSelectedIndexs];
    [self adjustTableViews];
    
    if (!self.superview) {
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        self.alpha = .0f;
        [UIView animateWithDuration:0.25f animations:^{
            self.alpha = 1.0f;
        }];
    }
    
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self];
}

- (void)wb_dismissView {
    if (self.superview) {
        [UIView animateWithDuration:.25f animations:^{
            self.alpha = .0f;
        } completion:^(BOOL finished) {
            [self.bgView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
                [obj removeFromSuperview];
            }];
            [self removeFromSuperview];
            
            if ([self.delegate respondsToSelector:@selector(wb_associationView_dismiss)]) {
                [self.delegate wb_associationView_dismiss];
            }
        }];
    }
}

#pragma mark -- UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableView *t0 = [self.tables objectAtIndex:0];
    UITableView *t1 = [self.tables objectAtIndex:1];
    UITableView *t2 = [self.tables objectAtIndex:2];
    
    UITableViewCell *cell = nil;
    if ((tableView == t0) && [self.delegate respondsToSelector:@selector(wb_tableViewForLevel_0:
                                                                         cellForRowAtIndexPath:)]) {
        cell = [self.delegate wb_tableViewForLevel_0:tableView
                               cellForRowAtIndexPath:indexPath];
    }
    else if ((tableView == t1) && [self.delegate respondsToSelector:@selector(wb_tableViewForLevel_1:
                                                                              cellForRowAtIndexPath:
                                                                              didSelectRowInLevel_0:)]) {
        cell = [self.delegate wb_tableViewForLevel_1:tableView
                               cellForRowAtIndexPath:indexPath
                               didSelectRowInLevel_0:t0.indexPathForSelectedRow.row];
    }
    else if ((tableView == t2) && [self.delegate respondsToSelector:@selector(wb_tableViewForLevel_2:
                                                                              cellForRowAtIndexPath:
                                                                              didSelectRowInLevel_0:
                                                                              level_1:)]) {
        cell = [self.delegate wb_tableViewForLevel_2:tableView
                               cellForRowAtIndexPath:indexPath
                               didSelectRowInLevel_0:t0.indexPathForSelectedRow.row
                                             level_1:t1.indexPathForSelectedRow.row];
    }
    else {
        cell = [[UITableViewCell alloc] init];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    UITableView *t0 = [self.tables objectAtIndex:0];
    UITableView *t1 = [self.tables objectAtIndex:1];
    UITableView *t2 = [self.tables objectAtIndex:2];
    
    NSInteger count = 0;
    
    if (tableView == t0 && [_delegate respondsToSelector:@selector(wb_numberForLevel_0)]) {
        count = [_delegate wb_numberForLevel_0];
    }
    else if (tableView == t1 && [_delegate respondsToSelector:@selector(wb_numberForLevel_1_didSelectRowInLevel_0:)]) {
        NSInteger t0_selectedRow = t0.indexPathForSelectedRow.row;
        if (t0_selectedRow >= 0) {
            count = [_delegate wb_numberForLevel_1_didSelectRowInLevel_0:t0_selectedRow];
        }
        else {
            count = 0;
        }
    }
    else if (tableView == t2 && [_delegate respondsToSelector:@selector(wb_numberForLevel_2_didSelectRowInLevel_0:
                                                                        level_1:)]) {
        NSInteger t0_selectedRow = t0.indexPathForSelectedRow.row;
        NSInteger t1_selectedRow = t1.indexPathForSelectedRow.row;
        if ((t0_selectedRow >= 0) && (t1_selectedRow >= 0)) {
            count = [_delegate wb_numberForLevel_2_didSelectRowInLevel_0:t0_selectedRow
                                                                 level_1:t1_selectedRow];
        }
        else {
            count = 0;
        }
    }
    
    return count;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableView *t0 = [self.tables objectAtIndex:0];
    UITableView *t1 = [self.tables objectAtIndex:1];
    UITableView *t2 = [self.tables objectAtIndex:2];
    
    BOOL isNexClass = true;
    
    if (tableView == t0) {
        if ([self.delegate respondsToSelector:@selector(wb_tableView:didSelectRowInLevel_0:)]) {
            isNexClass = [_delegate wb_tableView:tableView didSelectRowInLevel_0:indexPath.row];
        }
        
        if (isNexClass) {
            [t1 reloadData];
            if (!t1.superview) {
                [self.bgView addSubview:t1];
            }
            if (t2.superview) {
                [t2 removeFromSuperview];
            }
            [self adjustTableViews];
        }
        else {
            if (t1.superview) {
                [t1 removeFromSuperview];
            }
            if (t2.superview) {
                [t2 removeFromSuperview];
            }
            [self saveSelectedIndexs];
        }
    }
    else if (tableView == t1) {
        if ([self.delegate respondsToSelector:@selector(wb_tableView:
                                                        didSelectRowInLevel_0:
                                                        level_1:)]) {
            isNexClass = [_delegate wb_tableView:tableView
                           didSelectRowInLevel_0:t0.indexPathForSelectedRow.row
                                         level_1:indexPath.row];
        }
        
        if (isNexClass) {
            [t2 reloadData];
            if (!t2.superview) {
                [self.bgView addSubview:t2];
            }
            [self adjustTableViews];
        }
        else {
            if (t2.superview) {
                [t2 removeFromSuperview];
            }
            [self adjustTableViews];
            [self saveSelectedIndexs];
        }
    }
    else if (tableView == t2) {
        if ([self.delegate respondsToSelector:@selector(wb_tableView:
                                                        didSelectRowInLevel_0:
                                                        level_1:
                                                        level_2:)]) {
            isNexClass = [_delegate wb_tableView:tableView
                           didSelectRowInLevel_0:t0.indexPathForSelectedRow.row
                                         level_1:t1.indexPathForSelectedRow.row
                                         level_2:indexPath.row];
        }
        
        if (isNexClass) {
            [self saveSelectedIndexs];
        }
    }
    
    //[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

@end
