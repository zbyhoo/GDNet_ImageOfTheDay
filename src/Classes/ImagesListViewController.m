//
//  ImagesListViewController.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/26/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "ImagesListViewController.h"
#import "PostDetailsController.h"
#import "DataManager.h"
#import "DBHelper.h"
#import "GDArchiveHtmlStringConverter.h"
#import "GDImagePost.h"
#import "GDPicture.h"

@interface ImagesListViewController (Protected)

- (void)updatePostAtIndex:(NSIndexPath*)indexPath cell:(TableViewCell*)cell;
- (BOOL)isRefreshHeaderNeeded;
- (void)createRefreshHeader;
- (NSString*)getDateFromPost:(GDImagePost*)post;
- (UIImage*)getMainPicture:(GDImagePost*)post;
- (void)setupRefreshHeader;
- (void)configureRefreshHeader;
- (TableViewCell*)createCell:(UITableView*)tableView;
    
@end

@implementation ImagesListViewController

@synthesize dataManager         = _dataManager;
@synthesize refreshHeaderView   = _refreshHeaderView;

@synthesize reloading = _reloading;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNavigationButtons];
    [self setupRefreshHeaderAndFooter];
    [self setupDataManager];
    
    [self.dataManager preloadData:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [self.dataManager refresh:self.tableView];
    [super viewWillAppear:animated];
}

- (void)setupDataManager
{
    DataManager *manager = [[DataManager alloc] initWithDataType:POST_NORMAL];
    self.dataManager = manager;
    [manager release];
}

- (void)setupRefreshHeaderAndFooter 
{
    if ([self isRefreshHeaderNeeded]) 
    {
		[self createRefreshHeader];
        [self setupRefreshHeader];
	}
}

- (void)setupNavigationButtons
{
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] 
                                   initWithTitle:@"back" 
                                   style:UIBarButtonItemStyleBordered 
                                   target:nil 
                                   action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
}

- (BOOL)isRefreshHeaderNeeded
{
    return self.refreshHeaderView == nil;
}

- (void)setupRefreshHeader
{
    [self.tableView addSubview:self.refreshHeaderView];
    [self.refreshHeaderView refreshLastUpdatedDate];
    self.reloading = NO;
}

- (void)createRefreshHeader
{
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] 
                                       initWithFrame:CGRectMake(0.0f, 
                                                                0.0f - self.tableView.bounds.size.height, 
                                                                self.view.frame.size.width, 
                                                                self.tableView.bounds.size.height)];
    view.delegate = self;
    self.refreshHeaderView = view;
    [view release];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataManager postsCount];
}

- (TableViewCell*)createCell:(UITableView*)tableView
{
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) 
    {
        [[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil];
        cell = tblCell;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    TableViewCell *cell = [self createCell:tableView];    
    [self updatePostAtIndex:indexPath cell:cell];
    
    return cell;
}

- (NSString*)getDateFromPost:(GDImagePost*)post
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[post.postDate intValue]];
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"MM.dd.yyyy"];
    return [df stringFromDate:date];
}

- (UIImage*)getMainPicture:(GDImagePost*)post
{
    for (GDPicture *picture in post.pictures) 
    {
        if (picture.pictureDescription != nil && [picture.pictureDescription compare:MAIN_IMAGE_OBJ] == NSOrderedSame)
        {
            return [UIImage imageWithData:picture.smallPictureData];
        }
    }
    return nil;
}

- (void)updatePostAtIndex:(NSIndexPath*)indexPath cell:(TableViewCell*)cell 
{    
    GDImagePost* post = [self.dataManager getPostAtIndex:indexPath];
    
    cell.titleLabel.text        = post.title;
    cell.authorLabel.text       = post.author;
    cell.dateLabel.text         = [self getDateFromPost:post];
    cell.postImageView.image    = [self getMainPicture:post];
}

- (void)reloadCellAtIndexPath:(NSIndexPath*)indexPath
{
    UITableView* tableView = (UITableView*) self.view;
    NSArray* array = [[NSArray alloc] initWithObjects:indexPath,nil];
    [tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
    [array release];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        [self.dataManager markDeleted:indexPath];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}   

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if (editing) {
        // you might disable other widgets here... (optional)
    } else {
        // re-enable disabled widgets (optional)
    }
}
*/

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostDetailsController *imageDetailViewController = [[PostDetailsController alloc] 
                                                            initWithNibName:@"PostDetailsController" bundle:nil];
    
    imageDetailViewController.title     = [self.dataManager getTitleOfPostAtIndex:indexPath];
    imageDetailViewController.postId    = [self.dataManager getPostIdAtIndex:indexPath];
    imageDetailViewController.dataType  = self.dataManager.dataType;
    
    [self.navigationController pushViewController:imageDetailViewController animated:YES];
    [imageDetailViewController release];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{	
	return self.reloading;	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{	
	return [NSDate date];	
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource 
{
    [self.dataManager refreshFromWeb:self.tableView];
	self.reloading = YES;	
}

- (void)doneLoadingTableViewData 
{
	self.reloading = NO;
	[self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];	
}

- (void)reloadData 
{
    [self doneLoadingTableViewData];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc 
{
    self.refreshHeaderView = nil;
    self.dataManager = nil;
    [super dealloc];
}


@end

