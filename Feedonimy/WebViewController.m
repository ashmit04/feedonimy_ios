//
//  WebViewController.m
//  Feedonimy
//
//  Created by Ashmit Chhabra on 8/16/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import "WebViewController.h"
#import "NSString+URLEncoding.h"
#import "SavedArticles+Articles.h"
#import "DatabaseHelper.h"
#import "ToastAlert.h"
#import <QuartzCore/QuartzCore.h>
@interface WebViewController()<UIWebViewDelegate>{
    BOOL articleSavedAsRead;
    UIView* loadingView;
}
@end
@implementation WebViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.webView.delegate = self;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    self.url =[self.url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    // NSString *urlEncoded = [[NSString alloc]initWithString:[self.url urlEncodeUsingEncoding:NSUTF8StringEncoding]];
    //[NSURL URLWithString:self.url];
     NSURL *myURL = [NSURL URLWithString: [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   // NSLog(@"MYURL = %@",myURL);
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareArticle:)];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(saveArticle:)];
    
    
    [[DatabaseHelper sharedManagedDocument] performWithDocument:^(UIManagedDocument *document) {
        self.context = document.managedObjectContext;
        NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"SavedArticles"];
        request.predicate = [NSPredicate predicateWithFormat:@"title = %@",self.articleTitle];
        //request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO]];
        NSError * error;
        
        NSArray * matches = [self.context executeFetchRequest:request error:&error];
        if ([matches count]>0) {
            addItem.tintColor = [UIColor greenColor];
            articleSavedAsRead = YES;
        }
        else if ([matches count]==0){
            addItem.tintColor = [UIColor whiteColor];
            articleSavedAsRead = NO;
        }
    }];
    NSArray *actionButtonItems = @[shareItem, addItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    NSURLRequest * request = [NSURLRequest requestWithURL:myURL ];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
    loadingView = [[UIView alloc]initWithFrame:CGRectMake(self.webView.center.x-30, self.webView.center.y, 80, 80)];
    loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.6];
    loadingView.layer.cornerRadius = 5;
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(loadingView.frame.size.width / 2.0, 35);
    [activityView startAnimating];
    activityView.tag = 100;
    [loadingView addSubview:activityView];
    
    UILabel* lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, 80, 30)];
    lblLoading.text = @"Loading...";
    lblLoading.textColor = [UIColor whiteColor];
    lblLoading.font = [UIFont fontWithName:lblLoading.font.fontName size:15];
    lblLoading.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:lblLoading];
    
    [self.view addSubview:loadingView];
}
-(void)setContext:(NSManagedObjectContext *)context{
    _context = context;
}
-(void)shareArticle:(id)sender {
    self.url =[self.url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //NSURL *myURL = [NSURL URLWithString: [self.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString * messageToShare =[NSString stringWithFormat:@"Hey Check this out: %@ \n %@",self.articleTitle,self.url];
    NSArray *objectsToShare = @[messageToShare];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludedActivities = @[UIActivityTypePostToWeibo,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    
    // Present the controller
    [self presentViewController:controller animated:YES completion:nil];
}
-(void)saveArticle:(id)sender {
    NSMutableDictionary * savedArticleDetails = [[NSMutableDictionary alloc] init];
    [savedArticleDetails setObject: self.url forKey:@"webURL" ];
    [savedArticleDetails setObject: self.articleTitle forKey:@"articleTitle" ];
    [savedArticleDetails setObject: self.summary forKey:@"summary" ];
    [savedArticleDetails setObject: self.imageURL forKey:@"imageURL"];
    [savedArticleDetails setObject: self.category forKey:@"category" ];
    [savedArticleDetails setObject: self.datePublished forKey:@"datePublished" ];
    
    [[DatabaseHelper sharedManagedDocument] performWithDocument:^(UIManagedDocument *document) {
        self.context = document.managedObjectContext;
        NSArray * buttonItems = self.navigationItem.rightBarButtonItems;
        UIBarButtonItem * savedButton = [buttonItems lastObject];
        NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"SavedArticles"];
        request.predicate = [NSPredicate predicateWithFormat:@"title = %@",self.articleTitle];
        //request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO]];
        NSError * error;
        
        NSArray * matches = [self.context executeFetchRequest:request error:&error];
        if ([matches count]>0) {
            savedButton.tintColor = [UIColor whiteColor];
            [SavedArticles deleteArticleWithTitle:self.articleTitle inManagedObjectContext:self.context];
            [self.view addSubview: [[ToastAlert alloc] initWithText: @"Marked as Read"]];
        }
        else if ([matches count]==0){
            savedButton.tintColor = [UIColor greenColor];
            [SavedArticles addArticle:savedArticleDetails intoManagedObjectContext:self.context];
            [self.view addSubview: [[ToastAlert alloc] initWithText: @"Saved For Later"]];
        }
        NSArray * newbarItemArray = @[buttonItems.firstObject,savedButton];
        self.navigationItem.rightBarButtonItems = newbarItemArray;
        [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
    }];
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [loadingView setHidden:NO];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [loadingView setHidden:YES];
}
@end
