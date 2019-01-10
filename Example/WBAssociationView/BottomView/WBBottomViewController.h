//
//  WBBottomViewController.h
//
//  Created by penghui8 on 2019/1/9.
//  Copyright © 2019 penghui8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBAssociationBottomView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBBottomViewController : UIViewController

@property (nonatomic, strong, readonly) WBAssociationBottomView *bottomView;

@property (nonatomic, strong, readonly) NSArray<WBAssociationItem *> *dataSource;

+ (instancetype)viewControllerWithKey:(NSString *)key;

- (void)wb_viewConfigure NS_REQUIRES_SUPER;

- (void)wb_updateBottomView;

- (void)wb_allItemSelected:(BOOL)selected;

- (void)wb_deletedItem:(WBAssociationItem *)item;

- (void)wb_clearAllItem;

@end

NS_ASSUME_NONNULL_END
