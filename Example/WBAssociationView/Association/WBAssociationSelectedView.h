//
//  WBAssociationSelectedView.h
//
//  Created by penghui8 on 2018/12/25.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import "WBGestureView.h"
#import "WBAssociationItem.h"
#import "WBAssociationConstants.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^WBAssociationDeletedCompletion)(NSInteger index);

@interface WBAssociationSelectedView : WBGestureView

@property (nonatomic, copy) WBAssociationDeletedCompletion deletedCompletion;

@property (nonatomic, copy) WBAssociationClearTrashCompletion clearTrashCompletion;

+ (instancetype)viewWithFrame:(CGRect)frame;

- (void)wb_loadData:(NSArray<WBAssociationItem *> *)items;

- (CGFloat)wb_viewHeight;

@end

NS_ASSUME_NONNULL_END
