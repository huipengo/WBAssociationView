//
//  WBAssociationCell.h
//
//  Created by penghui8 on 2018/12/9.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBAssociationItem;

NS_ASSUME_NONNULL_BEGIN

@interface WBAssociationCell : UITableViewCell

+ (instancetype)wb_cellNibForTableView:(UITableView * _Nonnull)tableView;

- (void)setItem:(WBAssociationItem *)item;

- (void)wb_updateText:(BOOL)highlighted;

@end

NS_ASSUME_NONNULL_END
