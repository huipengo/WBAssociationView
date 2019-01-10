//
//  WBAssociationCell.m
//
//  Created by penghui8 on 2018/12/9.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import "WBAssociationCell.h"
#import "WBAssociationItem.h"
#import "NSString+Ex.h"
#import "UIColor+Ex.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface WBAssociationCell ()

@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badge_constraint_w;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badge_constraint_h;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) WBAssociationItem *item;

@end

@implementation WBAssociationCell

+ (instancetype)wb_cellNibForTableView:(UITableView * _Nonnull)tableView {
    static NSString *cellIdentifier = @"wb_cellNibIdentifier";
    WBAssociationCell *cell = [self.class wb_cellNibForTableView:tableView identifier:cellIdentifier];
    return cell;
}

+ (instancetype)wb_cellNibForTableView:(UITableView * _Nonnull)tableView identifier:(NSString * _Nonnull)identifier {
    WBAssociationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSString *nibName = NSStringFromClass(self.class);
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.highlightedTextColor = [UIColor wb_blueColor];
}

- (void)setItem:(WBAssociationItem *)item {
    _item = item;
    
    self.titleLabel.text = item.name;
    [self.titleLabel sizeToFit];
    
    @weakify(self)
    [RACObserve(item, selected) subscribeNext:^(NSNumber * _Nullable _selected) {
        @strongify(self)
        [self wb_updateText:_selected.boolValue];
    }];
    
    if (self.item.s_items.count > 0) {
        [self.item.s_items enumerateObjectsUsingBlock:^(WBAssociationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [RACObserve(obj, selected) subscribeNext:^(id  _Nullable x) {
                @strongify(self)
                NSInteger selected_count = self.item.selected_count;
                [self wb_updateBadge:selected_count];
            }];
        }];
    }
    else {
        [self wb_updateBadge:self.item.selected_count];
    }
}

- (void)wb_updateText:(BOOL)highlighted {
    self.titleLabel.textColor = highlighted ? [UIColor wb_blueColor] : [UIColor wb_blackColor];
    CGFloat pointSize = self.titleLabel.font.pointSize;
    UIFont *font      = [UIFont systemFontOfSize:pointSize];
    UIFont *b_font    = [UIFont boldSystemFontOfSize:pointSize];
    self.titleLabel.font = highlighted ? b_font : font;
}

- (void)wb_updateBadge:(NSInteger)selected_count {
    self.badgeLabel.hidden = (selected_count <= 0);
        
    if (selected_count > 0) {
        NSString *badge = [NSString stringWithFormat:@"%ld", (long)selected_count];
        self.badgeLabel.text = badge;
        CGSize size = [badge sizeWithBoundingRectSize:CGSizeMake(30.0f, self.frame.size.height)
                                        attributeFont:self.badgeLabel.font];
        CGFloat badge_w = MAX(14.0f, size.width);
        CGFloat badge_h = MAX(14.0f, size.height);
        
        self.badge_constraint_w.constant    = badge_w;
        self.badge_constraint_h.constant    = badge_h;
        self.badgeLabel.layer.cornerRadius  = (badge_w / 2.0f);
        self.badgeLabel.layer.masksToBounds = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    NSInteger selected_count = self.item.selected_count;
    if (self.item.s_items.count > 0) {
        [self wb_updateText:(selected || selected_count > 0)];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.titleLabel.highlighted = highlighted;
}

//- (void)wb_setBackgroundColorDidSelected:(BOOL)isSelected {
//    
//}

@end
