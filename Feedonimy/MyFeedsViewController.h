//
//  MyFeedsViewController.h
//  Feedonimy
//
//  Created by Ashmit Chhabra on 8/14/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CoreDataTableViewController.h"
@interface MyFeedsViewController :CoreDataTableViewController {
    NSXMLParser * parser;// download and parse the RSS XML files
    NSMutableArray * feeds;//list of feeds downloaded
    NSMutableArray * feedsCopy;
    UIView* loadingView;
    NSString * oldTitle;

}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
//@property(strong,nonatomic)NSMutableArray * feeds;
//list of mediaURl
@property(nonatomic,strong)NSString * category;
@property(nonatomic,strong) NSManagedObjectContext * context;
@end
