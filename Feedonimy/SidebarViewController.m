//
//  Feedonimy
//
//  Created by Ashmit Chhabra on 7/24/14.
//  Copyright (c) 2014 ARO. All rights reserved.

#import "SidebarViewController.h"

#import "SWRevealViewController.h"
#import "MenuFeedsTVC.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@property(nonatomic)NSInteger currentRow;

@end

@implementation SidebarViewController
//static UIColor *SelectedCellBGColor = [UIColor redColor];
//static UIColor *NotSelectedCellBGColor = ;

-(void)setCurrentRow:(NSInteger)currentRow{
    
        _currentRow = currentRow;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    //Set frame for tableview
    //[self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.picker.frame.size.height)];
    _menuItems =@[@"title",@"trending",@"technology",@"headlines",@"sports",@"entertainment",@"business",@"gaming"];
    
     

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UIView *bgColorView = [[UIView alloc] init];
    //bgColorView.backgroundColor = [UIColor redColor];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}


//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSIndexPath *currentSelectedIndexPath = [tableView indexPathForSelectedRow];
//    if (currentSelectedIndexPath != nil)
//    {
//        [[tableView cellForRowAtIndexPath:currentSelectedIndexPath] setBackgroundColor:[UIColor colorWithWhite:0.2f alpha:1.0f]];
//    }
//    
//    return indexPath;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=0)
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor redColor]];
    
    self.currentRow = indexPath.row;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[cell setBackgroundColor:[UIColor colorWithWhite:0.2f alpha:1.0f]];
    //NSLog(@"indexpath.row = %ld & currentrow = %ld",(long)indexPath.row,(long)self.currentRow);
    if (indexPath.row == self.currentRow && indexPath.row != 0)
    {
        [cell setBackgroundColor:[UIColor redColor]];
    }
    else
    {
       
        [cell setBackgroundColor:[UIColor colorWithWhite:0.2f alpha:1.0f]];
    }
}

//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    cell.backgroundColor =[UIColor colorWithWhite:0.2f alpha:1.0f];
//}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController * destController = (UINavigationController *)segue.destinationViewController;
    destController.title = [[_menuItems objectAtIndex:indexPath.row]capitalizedString];
    if([segue.identifier isEqualToString:@"showFeeds"]){
       
       MenuFeedsTVC *mftvc = (MenuFeedsTVC *)segue.destinationViewController;
        
        mftvc.menuItem = [_menuItems objectAtIndex:indexPath.row];
        //NSLog(@"here in segue");

        
    }
    if([segue isKindOfClass:[SWRevealViewControllerSegue class]]){
        
        SWRevealViewControllerSegue * swSegue = (SWRevealViewControllerSegue *)segue;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }

}
@end
