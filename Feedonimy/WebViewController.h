//
//  WebViewController.h
//  Feedonimy
//
//  Created by Ashmit Chhabra on 8/16/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (copy, nonatomic) NSString *articleTitle;
@property(weak,nonatomic)NSString *summary;
@property(weak,nonatomic)NSString * imageURL;
@property(weak,nonatomic)NSDate * datePublished;
@property (copy, nonatomic) NSString *url;
@property (weak, nonatomic) NSString *category;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong) NSManagedObjectContext * context;
@end
