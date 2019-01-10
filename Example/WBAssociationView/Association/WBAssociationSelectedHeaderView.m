//
//  WBAssociationSelectedHeaderView.m
//
//  Created by penghui8 on 2018/12/25.
//  Copyright © 2018 penghui8. All rights reserved.
//

#import "WBAssociationSelectedHeaderView.h"

@interface WBAssociationSelectedHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WBAssociationSelectedHeaderView

+ (instancetype)viewWithOwner:(id)owner {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class)
                                         owner:owner options:nil].firstObject;
}

- (IBAction)wb_trashAction:(id)sender {
    !self.clearTrashCompletion ?: self.clearTrashCompletion();
}

@end
