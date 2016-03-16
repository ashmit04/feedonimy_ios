//
//  MenuFeedsTVC.h
//  Feedonimy
//
//  Created by Ashmit Chhabra on 8/25/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import "MyFeedsViewController.h"

@interface MenuFeedsTVC : MyFeedsViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton1;

@property(nonatomic,strong)NSString * menuItem;
@end
