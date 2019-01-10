//
//  WBAssociationBottomView.m
//
//  Created by penghui8 on 2018/12/13.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import "WBAssociationBottomView.h"
#import "UIColor+Ex.h"
#import "UIButton+Ex.h"
#import "UIView+Ex.h"
#import "WBConfigure.h"
#import "WBAssociationSelectedView.h"
#import <ReactiveObjC/ReactiveObjC.h>

CGFloat const wb_bottom_view_height = 50.0f;

@interface WBAssociationBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *done_button;

@property (weak, nonatomic) IBOutlet UIButton *selected_button;

@property (weak, nonatomic) IBOutlet UIButton *all_select_button;

@property (nonatomic, strong) NSMutableArray<WBAssociationItem *> *items;

@property (nonatomic, strong) WBAssociationSelectedView *selectedView;

@property (nonatomic, assign) BOOL wb_showSelectedView;

@end

@implementation WBAssociationBottomView

+ (instancetype)viewWithOwner:(id)owner {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class)
                                         owner:owner options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _done_button.layer.cornerRadius = 4.0f;
    _done_button.layer.masksToBounds = YES;
    [_done_button.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [_done_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_done_button setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.8f] forState:UIControlStateHighlighted];
    [_done_button setBackgroundColor:[UIColor wb_blueColor] forState:UIControlStateNormal];
    [_done_button setBackgroundColor:[UIColor wb_blueColor_H] forState:UIControlStateHighlighted];
    
    [_all_select_button setTitleColor:[UIColor wb_blackColor] forState:UIControlStateNormal];
    [_all_select_button setTitleColor:[UIColor wb_blueColor] forState:UIControlStateSelected];
    [_all_select_button setImage:[UIImage imageNamed:@"wb_directional_unselected"] forState:UIControlStateNormal];
    [_all_select_button setImage:[UIImage imageNamed:@"wb_directional_selected"]   forState:UIControlStateSelected];
    
    [self wb_updateSelectedCount:0];
    
    @weakify(self)
    [RACObserve(self, wb_showSelectedView) subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        UIImage *up_image   = [UIImage imageNamed:@"wb_arrow_up_bold"];
        UIImage *down_image = [UIImage imageNamed:@"wb_arrow_down_bold"];
        [self.selected_button setImage:x.boolValue ? down_image : up_image forState:UIControlStateNormal];
    }];
}

- (void)wb_updateAllSelectState:(BOOL)isAllSelect {
    self.all_select_button.selected = isAllSelect;
}

- (void)wb_updateSelectedItems:(NSArray<WBAssociationItem *> *)items {
    [self.items removeAllObjects];
    [self.items addObjectsFromArray:items];
    
    [self.selectedView wb_loadData:self.items];
    
    [self wb_updateSelectedCount:items.count];
}

- (void)wb_updateSelectedCount:(NSInteger)selectedCount {
    NSString *keyword = [NSString stringWithFormat:@"%ld", (long)selectedCount];
    NSString *title = [NSString stringWithFormat:@"已选 %@ 个", keyword];    
    UILabel *titleLabel = self.selected_button.titleLabel;
    UIFont *bold_font   = [UIFont boldSystemFontOfSize:titleLabel.font.pointSize];
    NSMutableAttributedString *attributedString = [self.class attributedText:title
                                                                  keyword:keyword
                                                             keywordColor:[UIColor wb_blueColor]
                                                                     font:bold_font];
    [self.selected_button setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    [self wb_horizontal_text_image:self.selected_button];
}

- (void)wb_horizontal_text_image:(UIButton *)sender {
    CGFloat margin = 3.0f;
    CGFloat image_width = (sender.imageView.image.size.width + margin);
    CGFloat title_width = (sender.titleLabel.bounds.size.width + margin);
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsMake(0.0f, -image_width, 0.0f, image_width);
    [sender setTitleEdgeInsets:titleEdgeInsets];
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsMake(0.0f, title_width, 0.0f, -title_width);
    [sender setImageEdgeInsets:imageEdgeInsets];
}

+ (NSMutableAttributedString *)attributedText:(NSString *)text
                                      keyword:(NSString *)keyword
                                 keywordColor:(UIColor *)keywordColor
                                         font:(UIFont *)font {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text?:@""];
    NSRange range = [text rangeOfString:keyword?:@"" options:NSCaseInsensitiveSearch];
    if (text && range.location != NSNotFound) {
        NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName : keywordColor};
        [attributedString addAttributes:attributes range:range];
    }
    return attributedString;
}

#pragma mark -- action
- (IBAction)wb_doneAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(wb_bottomView:doneAction:)]) {
        [self.delegate wb_bottomView:self doneAction:sender];
    }
}

- (IBAction)wb_selectedAction:(UIButton *)sender {
    [self wb_selectedViewAction];

    if ([self.delegate respondsToSelector:@selector(wb_bottomView:selectedAction:)]) {
        [self.delegate wb_bottomView:self selectedAction:sender];
    }
}

- (IBAction)wb_allSelectAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if ([self.delegate respondsToSelector:@selector(wb_bottomView:allSelectAction:)]) {
        [self.delegate wb_bottomView:self allSelectAction:sender];
    }
}

- (void)wb_selectedViewAction {
    if (self.items.count <= 0) {
        /** 已选内容为空 ^_^ */
        return;
    }
    
    WBAssociationSelectedView *selectedView = self.selectedView;
    if (![selectedView isDescendantOfView:self.superview]) {
        CGFloat height = MIN([selectedView wb_viewHeight], [self wb_max_height]);
        CGRect frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, height);
        selectedView.frame = frame;
        [selectedView wb_showInView:self.superview];
        [self.superview bringSubviewToFront:self];
        self.wb_showSelectedView = YES;
    }
    else if (selectedView.wb_show) {
        [self wb_hiddenSelectedView];
    }
}

- (CGFloat)wb_max_height {
    CGFloat max_height = (self.superview.height - wb_status_navBarHeight() - self.height - 100.0f);
    return max_height;
}

- (void)wb_hiddenSelectedView {
    [self.selectedView wb_hiddenView];
}

#pragma mark --
- (WBAssociationSelectedView *)selectedView {
    if (!_selectedView) {
        _selectedView = ({
            CGFloat height = [self wb_max_height];
            CGRect frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, height);
            WBAssociationSelectedView *view = [WBAssociationSelectedView viewWithFrame:frame];
            view.hidden_remove  = YES;
            view.show_mask_view = YES;
            view.bottom_margin  = self.height;
            
            @weakify(self)
            view.deletedCompletion = ^(NSInteger index) {
                @strongify(self)
                WBAssociationItem *item = [self.items objectAtIndex:index];
                item.selected = !item.selected;
                [self.items removeObject:item];
                if ([self.delegate respondsToSelector:@selector(wb_bottomView:deletedAction:)]) {
                    [self.delegate wb_bottomView:self deletedAction:item];
                }
            };
            
            view.clearTrashCompletion = ^{
                @strongify(self)
                [self.items enumerateObjectsUsingBlock:^(WBAssociationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.selected = !obj.selected;
                }];
                [self.items removeAllObjects];
                [self wb_hiddenSelectedView];
                if ([self.delegate respondsToSelector:@selector(wb_bottomView_clearTrashAction:)]) {
                    [self.delegate wb_bottomView_clearTrashAction:self];
                }
            };
            
            view.hiddenCompletion = ^(BOOL finished) {
                @strongify(self)
                self.wb_showSelectedView = NO;
            };
            view;
        });
    }
    return _selectedView;
}

- (NSMutableArray<WBAssociationItem *> *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

@end
