//
//  WBAssociationSelectedHeaderView.h
//
//  Created by penghui8 on 2018/12/25.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBAssociationConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface WBAssociationSelectedHeaderView : UIView

@property (nonatomic, copy) WBAssociationClearTrashCompletion clearTrashCompletion;

+ (instancetype)viewWithOwner:(id)owner;

@end

NS_ASSUME_NONNULL_END
