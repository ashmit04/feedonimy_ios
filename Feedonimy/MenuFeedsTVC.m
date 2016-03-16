//
//  MenuFeedsTVC.m
//  Feedonimy
//
//  Created by Ashmit Chhabra on 8/25/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import "MenuFeedsTVC.h"
#import "FeedFetcher.h"
#import "SWRevealViewController.h"
#import "DatabaseHelper.h"
#import "AlertMessage.h"
#import "SavedArticles+Articles.h"
@interface MenuFeedsTVC(){
   
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end
@implementation MenuFeedsTVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    NSLog(@"here in view did load");
    self.category = self.menuItem;
        // Load image
    // _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton1.tintColor = [UIColor whiteColor];
    _sidebarButton1.target = self.revealViewController;
    _sidebarButton1.action = @selector(revealToggle:);
    self.segmentControl.tintColor =[UIColor whiteColor];
    [self.segmentControl setTitle:[self.menuItem capitalizedString] forSegmentAtIndex:0];
    //Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    

    [super viewDidLoad];
    self.title = [self.menuItem capitalizedString];

    
}
-(void)startParsingFeeds{
    
    feeds = [[NSMutableArray alloc]init];
    
    NSArray * mainFeedsURL = [[NSArray alloc]init];
    if([self.menuItem isEqualToString:@"trending"]){
        mainFeedsURL = [FeedFetcher URLForTrending];    
    }
    else if([self.menuItem isEqualToString:@"technology"]){
        mainFeedsURL = [FeedFetcher URLForTech];
    }
    else if([self.menuItem isEqualToString:@"headlines"]){
       mainFeedsURL = [FeedFetcher URLForHeadlines];
    }
    else if([self.menuItem isEqualToString:@"sports"]){
       mainFeedsURL = [FeedFetcher URLForSports];
    }
    else if([self.menuItem isEqualToString:@"entertainment"]){
       mainFeedsURL = [FeedFetcher URLForEntertainment];
    }
    else if([self.menuItem isEqualToString:@"business"]){
       mainFeedsURL = [FeedFetcher URLForBusiness];
    }
    else if([self.menuItem isEqualToString:@"gaming"]){
       mainFeedsURL = [FeedFetcher URLForGaming];
    }
    
    // NSLog(@"here %@",mainFeedsURL);
    for(NSString *urlString in mainFeedsURL){
        
        //  NSLog(@"here = %@",urlString);
        NSURL * url = [NSURL URLWithString:urlString];
        parser = [[NSXMLParser alloc]initWithContentsOfURL:url];
        
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
    }
}
- (IBAction)segmentControlChanged:(id)sender {
    UISegmentedControl * seg = sender;
    switch(seg.selectedSegmentIndex){
        case 0:
            self.title =oldTitle;
            if(feedsCopy)
                feeds = feedsCopy;
            //[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            [self.tableView reloadData];
            for (UIView *subView in self.view.subviews) {
                if (subView.tag == 1) {
                    
                    [subView removeFromSuperview];
                }
            }
            break;
        case 1:
            oldTitle = [[NSString alloc]initWithString:self.title];
            self.title = @"Saved";
            feedsCopy = [[NSMutableArray alloc]init];
            feedsCopy = feeds;
            [[DatabaseHelper sharedManagedDocument] performWithDocument:^(UIManagedDocument *document) {
                self.context = document.managedObjectContext;
                //[SavedArticles addArticle:savedArticleDetails intoManagedObjectContext:self.context];
                feeds = [SavedArticles fetchArticleFromDatabaseInManagedObjectContext:self.context];
                [self.tableView reloadData];
                //[self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
                if([feeds count]==0){
                    [self.view addSubview: [[AlertMessage alloc] initWithText: @"No Saved Items Available.Start browsing and save the articles you would like to read later."]];
                }
                [document saveToURL:document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
            }];
            break;
    }

}
@end
//_menuItems =@[@"title",@"trending",@"tech",@"headlines",@"sports",@"entertainment",@"business",@"addnew"];