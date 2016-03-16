//
//  MyFeedsViewController.m
//  Feedonimy
//
//  Created by Ashmit Chhabra on 8/14/14.
//  Copyright (c) 2014 ARO. All rights reserved.
//

#import "MyFeedsViewController.h"
#import "SWRevealViewController.h"
#import "FeedFetcher.h"
#import "CTCardCell.h"
#import "WebViewController.h"
#import "NSDate+InternetDateTime.h"
#import "SavedArticles+Articles.h"
#import "DatabaseHelper.h"
#import "AlertMessage.h"
#import "SettingsViewController.h"
@interface MyFeedsViewController(){
   
    //NSXMLParser * parser;// download and parse the RSS XML files
    NSMutableDictionary * item;// of title and link
    NSMutableString * title;
    NSMutableString * link;
    NSString * element; //element being currently parsed by the NSXMLParser object
    NSMutableString * imageUrl;
    NSMutableString * imageMediaUrl;
    NSMutableString * description;
    NSMutableString * mediaString;
    NSDateFormatter * pubDate;
    NSDate * date;
    NSMutableString * dateString;
    NSMutableString * enclosureMediaUrl;
    NSMutableString * mediaThumbnail;
    BOOL mediaContentFound;
    NSMutableString * feedLogo;
    NSMutableString * feedName;
       
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property(strong,nonatomic)UIViewController *currentViewController;
//@property(strong,nonatomic)NSMutableArray * mediaURLArray;
//@property(strong,nonatomic)NSMutableArray * enclosedMediaArray;
@property(strong,nonatomic)UIRefreshControl *refreshContrl;
@property(strong,nonatomic) NSMutableString * descriptionClone;
@property(assign,nonatomic) CATransform3D initialTranformation;
@property(nonatomic, strong) NSMutableSet * showIndexes;//of cards already displayed so that are not animated again when scrolling up

@end
@implementation MyFeedsViewController
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
-(void)setCategory:(NSString *)category{
    _category = category;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title =@"Trending";
    self.category = @"Trending";
    
//    for (UITextView *view in self.view.subviews) {
//        if ([view isKindOfClass:[UITextView class]]) {
//            view.scrollsToTop = NO;
//        }
//    }
    [self.tableView setScrollsToTop:YES];
    //self.mediaURLArray = [[NSMutableArray alloc]init];
    //self.enclosedMediaArray =[[NSMutableArray alloc]init];
    //self.title = @"My Feeds";
     _sidebarButton.tintColor = [UIColor whiteColor];
    self.refreshContrl = [[UIRefreshControl alloc]init];
    self.refreshContrl.tintColor = [UIColor magentaColor];
     [self.tableView addSubview:self.refreshContrl];
    [self.refreshContrl addTarget:self action:@selector(startParsingFeeds) forControlEvents:UIControlEventValueChanged];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    //Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
   
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back1.jpg"]];
    CGFloat rotationAngleDegrees = -15;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-20, -20);
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    _initialTranformation = transform;
    
    self.segmentControl.tintColor = [UIColor whiteColor];
//    UIViewController *vc = [self viewControllerForSegmentIndex:self.segmentControl.selectedSegmentIndex];
//    [self addChildViewController:vc];
//    vc.view.frame = self.view.bounds;
//    [self.view addSubview:vc.view];
//    self.currentViewController = vc;
    loadingView = [[UIView alloc]initWithFrame:CGRectMake(self.view.center.x-30, self.view.center.y-10, 80, 80)];
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
    
     [self startParsingFeeds];
    
}
//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

-(void)startParsingFeeds{
    
   // [self.spinner startAnimating];
    feeds = [[NSMutableArray alloc]init];
    NSArray * mainFeedsURL = [FeedFetcher URLForTrending];
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
-(void)setContext:(NSManagedObjectContext *)context{
    _context = context;
}
- (IBAction)segmentControlChanged:(id)sender {
    UISegmentedControl *seg = sender;
//    UIViewController *vc = [self viewControllerForSegmentIndex:seg.selectedSegmentIndex];
//    [self addChildViewController:vc];
//    [self transitionFromViewController:self.currentViewController toViewController:vc duration:0.5 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
//        [self.currentViewController.view removeFromSuperview];
//        vc.view.frame = self.view.bounds;
//        [self.view addSubview:vc.view];
//    } completion:^(BOOL finished) {
//        [vc didMoveToParentViewController:self];
//        [self.currentViewController removeFromParentViewController];
//        self.currentViewController = vc;
//    }];
//    self.navigationItem.title = vc.title;
    
    switch(seg.selectedSegmentIndex){
        case 0:
            self.title = oldTitle;
            if(feedsCopy)
                feeds = feedsCopy;
           // [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
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

-(NSMutableString *)getConstrainedDescriptionFrom:(NSMutableString *)descriptionString{
 
    NSRange r;
    
    while ((r = [descriptionString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        descriptionString = (NSMutableString*)[descriptionString stringByReplacingCharactersInRange:r withString:@""];

    descriptionString = (NSMutableString*)[descriptionString stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    const int clipLength = 200;
    if([descriptionString length]>clipLength)
    {
        descriptionString = (NSMutableString*)[NSString stringWithFormat:@"%@...",[descriptionString substringToIndex:clipLength]];
    }
//    NSData *stringData = [descriptionString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
//    descriptionString = (NSMutableString*)[[NSAttributedString alloc] initWithData:stringData
//                                                     options:options
//                                          documentAttributes:NULL
//                                                       error:NULL];
    return descriptionString;
}
-(NSString *)getImageURLFrom:(NSString *)descr{
   
    NSScanner *theScanner;
    NSString * imgURL=nil;

    theScanner = [NSScanner scannerWithString:descr];
    
    // find start of tag
    [theScanner scanUpToString: @"<img src=\""  intoString: NULL];
     if ([theScanner isAtEnd] == NO) {
         NSInteger newLoc = [theScanner scanLocation] + 10;
         [theScanner setScanLocation: newLoc];
         
         // find end of tag
         [theScanner scanUpToString: @"\"" intoString:&imgURL];
     }

    return imgURL;
}
-(NSString *)getValidImageURLForIndex:(NSInteger)index{
    
    NSString *imageURLString = [feeds[index] objectForKey:@"imageURL"];
    NSString * mediaURL = [feeds[index] objectForKey:@"imageMediaURL"];//[mediaArray objectAtIndex:index];
    NSString * enclosedMediaURL =[feeds[index] objectForKey:@"enclosedMediaURL"];//[enclosedMediaArray objectAtIndex:index];
    NSString * mediaThumbnailUrl = [feeds[index] objectForKey:@"mediaThumbnail"];
    // NSLog(@"imageurl = %@,media = %@, enclosed = %@",imageURLString,mediaURL,enclosedMediaURL);
    if([imageURLString length]<1){
        
        if([mediaURL length]>1)
            imageURLString = mediaURL;
        else if([enclosedMediaURL length]>1)
            imageURLString = enclosedMediaURL;
        else
            imageURLString = mediaThumbnailUrl;
    }
    else if([mediaURL length] >1 && [imageURLString length]>1){
        imageURLString = mediaURL;
    }
    else if([enclosedMediaURL length] >1 && [imageURLString length]>1 ){
        imageURLString = enclosedMediaURL;
    }
    else if([mediaThumbnailUrl length] >1 && [imageURLString length]>1 ){
        imageURLString = mediaThumbnailUrl;
    }
    return imageURLString;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    //NSLog(@"feeds count %lu media url array count = %d ,enclosed count =%d",(unsigned long)feeds.count,[self.mediaURLArray count],[self.enclosedMediaArray count]);
    return feeds.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:5];
    NSString *aboutText = [[feeds objectAtIndex:indexPath.row] objectForKey: @"description"];
    
    NSString *newlineString = @"\n";
    NSString *newAboutText = [aboutText stringByReplacingOccurrencesOfString:@"\\n" withString:newlineString];
    
    
    //CGSize aboutSize = [newAboutText sizeWithFont:font constrainedToSize:CGSizeMake(268, 4000)];
    
    // if deployment target is iOS7 and you want to get rid of the warning above
    // comment the line above and uncomment the following section
    
    // ios 7 only
    CGRect boundingRect = [newAboutText boundingRectWithSize:CGSizeMake(268, 4000)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    
    CGSize boundingSize = boundingRect.size;
    // end ios7 only
    
    
    return (280-15+boundingSize.height);
}//One more thing: Make sure to be efficient when drawing the cells, i.e. implement drawRect: instead of cluttering the cells with labels, views etc., this will make scrolling much faster.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Card";
    CTCardCell *cell = (CTCardCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   // NSLog(@"image set = %@",imageUrl);
    // NSString *descriptionString = [[feeds objectAtIndex:indexPath.row] valueForKey:@"description"];
//    if([imageUrl length]==0){
//        NSLog(@"Retrieving image");
//        [imageUrl appendString:[self getImageURLFrom:self.descriptionClone]];
//        NSLog(@" image  url = %@",imageUrl);
//    }
    
   // description = [self getConstrainedDescriptionFrom:description];
    // Configure the cell...
    if([imageUrl length]>0 || [imageMediaUrl length]>0 || [enclosureMediaUrl length]>0){
        //NSLog(@"imageurl = %@ and imageMedia =%@",imageUrl,imageMediaUrl);
        [cell setupWithDictionary:[feeds objectAtIndex:indexPath.row]
                          atIndex:indexPath.row];
    }
   
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(![self.showIndexes containsObject:indexPath]){//if this cell not already displayed
        [self.showIndexes addObject:indexPath];//add it to shown list and animate
        
        UIView * card = [(CTCardCell *)cell mainView];
        card.layer.transform = self.initialTranformation;
        card.layer.opacity = 0.8;
        
        [UIView animateWithDuration:0.4 animations:^{
            card.layer.transform = CATransform3DIdentity;
            card.layer.opacity = 1;
        }];
        
    }
}

-(IBAction)settingsChanged:(UIStoryboardSegue *)segue{
    
    if([segue.sourceViewController isKindOfClass:[SettingsViewController class]] ){
        //add functionality to do what to do when settings changed
        //SettingsViewController * settingsView = (SettingsViewController *)segue.sourceViewController;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showWebView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString * url = [feeds[indexPath.row] objectForKey:@"link"];
        NSString * articleTitle = [feeds[indexPath.row] objectForKey:@"title"];
        NSString * imageURL = [self getValidImageURLForIndex:indexPath.row];
        [[segue destinationViewController] setUrl:url];
        [[segue destinationViewController] setArticleTitle:articleTitle];
         [[segue destinationViewController] setImageURL:imageURL];
        [[segue destinationViewController] setSummary:[feeds[indexPath.row] objectForKey:@"description"]];
        [[segue destinationViewController] setDatePublished:[feeds[indexPath.row] objectForKey:@"publishedDate"]];
        [[segue destinationViewController] setCategory:self.category];
    }
}
#pragma mark -XMLParserdelegate Methods
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    element = elementName;
    
    if([element isEqualToString:@"item"]){
        item    = [[NSMutableDictionary alloc] init];
        title   = [[NSMutableString alloc] init];
        link    = [[NSMutableString alloc] init];
        imageUrl = [[NSMutableString alloc] init];
        description = [[NSMutableString alloc] init];
        pubDate = [[NSDateFormatter alloc]init];
        [pubDate setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZ"];
        dateString = [[NSMutableString alloc]init];
        imageMediaUrl =[[NSMutableString alloc] init];
        mediaThumbnail = [[NSMutableString alloc] init];
        enclosureMediaUrl =[[NSMutableString alloc] init];
        mediaContentFound = NO;
        feedLogo = [[NSMutableString alloc]init];
        feedName = [[NSMutableString alloc]init];
    }
//    else if ([element isEqualToString:@"media:thumbnail"]) {
//        if(!imageMediaUrl){
//            imageMediaUrl =[[NSMutableString alloc] init];
//            [imageMediaUrl appendString:[attributeDict objectForKey:@"url"]];
//        }
//    }
    else if ([element isEqualToString:@"media:content"]) {
       
       // NSLog(@"media url = %@",imageMediaUrl);
          if([imageMediaUrl length]<=0){
           [imageMediaUrl appendString:[attributeDict objectForKey:@"url"]];
           
            //mediaContentFound = YES;
             //NSLog(@"media content after = %hhd",mediaContentFound);
        }
        
    }
    else if ([element isEqualToString:@"media:thumbnail"]) {
        
        // NSLog(@"media url = %@",imageMediaUrl);
        if([mediaThumbnail length]<=0){
            [mediaThumbnail appendString:[attributeDict objectForKey:@"url"]];
           
        }
        
    }
    else if ([element isEqualToString:@"enclosure"]) {
        
        if([imageMediaUrl length]<=0){
            [enclosureMediaUrl appendString:[attributeDict objectForKey:@"url"]];
        }
    }
  
    
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
   
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    }
    else if ([element isEqualToString:@"description"]) {
       
        [description appendString:string];
    }
    else if ([element isEqualToString:@"pubDate"]) {
        //NSLog(@"appending string %@",string)
        //[dateString appendString:string];
       [dateString appendString: string];
        
    }
//    else if ([element isEqualToString:@"title"]) {
//        NSLog(@"here");
//        //[feedLogo appendFormat: [attributeDict]];
//        NSLog(@"title = %@",string);
//    }
   
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        [item setObject:title forKey:@"title"];
        
        [item setObject:link forKey:@"link"];
        
        self.descriptionClone = description;
       // description = [self getConstrainedDescriptionFrom:description];
        
        [item setObject:[self getConstrainedDescriptionFrom:description] forKey:@"description"];
        
        NSString * imageRetrieved = [self getImageURLFrom:self.descriptionClone];
//        [item setObject:feedLogo forKey:@"feedLogo"];
//        //NSLog(@"logo = %@",feedLogo);
//        
        if([imageRetrieved length]>0){
            [imageUrl appendString:imageRetrieved];
            [item setObject:imageUrl forKey:@"imageURL"];
            //NSLog(@"imageurl = %@",imageUrl);
        }
        else if([imageRetrieved length]<=0){
            [item setObject:@"" forKey:@"imageURL"];
        }
        //set object for mediaurl
       
        if([imageMediaUrl length]>0){
            if(![item objectForKey:@"imageMediaURL"]){
                
                [item setObject:imageMediaUrl forKey:@"imageMediaURL"];
            }
        }
        else{
             [item setObject:@"" forKey:@"imageMediaURL"];
        }
        if([mediaThumbnail length]>0){
            if(![item objectForKey:@"mediaThumbnail"]){
                
                [item setObject:mediaThumbnail forKey:@"mediaThumbnail"];
            }
        }
        else{
            [item setObject:@"" forKey:@"mediaThumbnail"];
        }
        
        if([enclosureMediaUrl length]>0){
            if(![item objectForKey:@"enclosedMediaURL"])
                [item setObject:enclosureMediaUrl forKey:@"enclosedMediaURL"];
        }
        else{
            [item setObject:@"" forKey:@"enclosedMediaURL"];
        }
       
        
        NSString * dateStr = [(NSString*)dateString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//@"Thu, 28 Aug 2014 16:00:00 +0000";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setDateFormat:@"EEE, d MMM yyyy HH:mm:ss ZZZ"];
        //NSDate *date = [dateFormatter dateFromString:dateString];
        date = [dateFormatter dateFromString:dateStr];
        
        //date = [NSDate dateFromInternetDateTimeString:dateStr formatHint:DateFormatHintRFC3339];
        if(!date){
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss zzz"];
            date = [dateFormatter dateFromString:dateStr];
        }
        if(!date){
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss"];
            date = [dateFormatter dateFromString:dateStr];
        }
         
        //NSLog(@"date %@",dateStr);
       // date = [dateFormatter dateFromString:dateStr];
       // NSLog(@"date %@",date);
        if(date)
            [item setObject:date forKey:@"publishedDate"];
        [feeds addObject:[item copy]];
        
        
    }
//    else if ([elementName isEqualToString:@"media:thumbnail"]) {
//        
//        if([imageMediaUrl length]>0)
//            [self.mediaURLArray addObject:imageMediaUrl];
//    }
//    else if ([elementName isEqualToString:@"media:content"]) {
//        
//        if([imageMediaUrl length]>0){
//            [self.mediaURLArray addObject:imageMediaUrl];
//        }
//    }
//    else if ([elementName isEqualToString:@"enclosure"]) {
//        
//        if([enclosureMediaUrl length]>0){
//         
//            [self.enclosedMediaArray addObject:enclosureMediaUrl];
//            //NSLog(@"Enclosure count= %d",[self.enclosedMediaArray count]);
//        }
//    }
    
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self sortArrayBasedOndate:feeds];
    [self.refreshContrl endRefreshing];
    [loadingView setHidden:YES];
    [self.tableView reloadData];
    //[self.spinner stopAnimating];
    
    
}
-(NSMutableArray *)sortArrayBasedOndate:(NSMutableArray *)arraytoSort
{
    
    NSComparator compareDates = ^(id date1, id date2)
    {
        
//        NSDate *date1 = [formatter dateFromString:string1];
//        NSDate *date2 = [formatter dateFromString:string2];
       //NSLog(@"string1 =%@ ,string2=%@",date1,date2);
        return [date1 compare:date2];
    };
    
    
    NSSortDescriptor * sortDesc1 = [[NSSortDescriptor alloc] initWithKey:@"publishedDate" ascending:NO comparator:compareDates];
    [arraytoSort sortUsingDescriptors:[NSArray arrayWithObjects:sortDesc1, nil]];
    
    
    return arraytoSort;
}
@end

//NSLog(@"description = %@",descriptionString);
//    NSScanner *theScanner;
//    NSString * htmltags=nil;
//
//    // find start of tag
//    theScanner = [NSScanner scannerWithString:descriptionString];
//
//    // find start of tag
//    [theScanner scanUpToString: @"<"  intoString: NULL];
//    if ([theScanner isAtEnd] == NO) {
//        NSInteger newLoc = [theScanner scanLocation] + 10;
//        [theScanner setScanLocation: newLoc];
//
//        // find end of tag
//        [theScanner scanUpToString: @">" intoString:&htmltags];
//    }
//
//    //NSLog(@"string to remove = %@",htmltags);
//    NSRange range = [descriptionString rangeOfString:htmltags];
//    [descriptionString deleteCharactersInRange:range];
//    [descriptionString stringByReplacingOccurrencesOfString:htmltags withString:@""];
//NSLog(@"string after remove = %@",descriptionString);
//descriptionString = (NSMutableString*)[[NSAttributedString alloc] initWithData:[descriptionString dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
