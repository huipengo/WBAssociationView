//
//  WBViewController.m
//  WBAssociationView_Example
//
//  Created by penghui8 on 2019/1/9.
//  Copyright © 2019 penghui8. All rights reserved.
//

#import "WBViewController.h"
#import "WBTagsViewController.h"
#import "WBAssociationViewController.h"

@interface WBViewController ()

@end

@implementation WBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)wb_associationViewAction:(id)sender {
    WBAssociationViewController *viewController = [WBAssociationViewController viewControllerWithKey:@"district"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)wb_tagsViewAction:(id)sender {
    WBTagsViewController *viewController = [WBTagsViewController viewControllerWithKey:@"app_category"];
    [self.navigationController pushViewController:viewController animated:YES];
}



@end
