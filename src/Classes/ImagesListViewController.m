//
//  ImagesListViewController.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/26/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "TableViewCell.h"
#import "ImagesListViewController.h"
#import "PostDetailsController.h"
#import "DataManager.h"
#import "DBHelper.h"
#import "GDArchiveHtmlStringConverter.h"
#import "GDImagePost.h"
#import "GDPicture.h"

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface ImagesListViewController (Protected)

- (void)updatePostAtIndex:(NSIndexPath*)indexPath cell:(TableViewCell*)cell;
- (BOOL)isRefreshHeaderNeeded;
- (BOOL)isRefreshFooterNeeded;
- (void)createRefreshHeader;
- (void)createRefreshFooter;
- (NSString*)getDateFromPost:(GDImagePost*)post;
- (UIImage*)getMainPicture:(GDImagePost*)post;
- (void)setupRefreshHeader;
- (void)setupRefreshFooter;
- (void)configureRefreshHeader;
- (TableViewCell*)createCell:(UITableView*)tableView;
- (float)tableViewHeight;
- (float)endOfTableView:(UIScrollView *)scrollView;
- (void)dataSourceDidFinishLoadingNewData;
- (void)repositionRefreshViews;
    
@end

@implementation ImagesListViewController

@synthesize dataManager         = _dataManager;
@synthesize refreshHeaderView   = _refreshHeaderView;
@synthesize refreshFooterView   = _refreshFooterView;

@synthesize reloadingHeader = _reloadingHeader;
@synthesize reloadingFooter = _reloadingFooter;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupNavigationButtons];
    [self setupRefreshHeaderAndFooter];
    [self setupDataManager];
    
    [self.dataManager preloadData:self];
    [self doneLoadingTableViewData];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [self.dataManager refresh:self];
    [super viewWillAppear:animated];
}

- (void)setupDataManager
{
    DataManager *manager = [[DataManager alloc] init];
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
    if ([self isRefreshFooterNeeded])
    {
        [self createRefreshFooter];
        [self setupRefreshFooter];
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

- (BOOL)isRefreshFooterNeeded
{
    return self.refreshFooterView == nil;
}

- (void)setupRefreshHeader
{
    [self.tableView addSubview:self.refreshHeaderView];
    self.reloadingHeader = NO;
}

- (void)setupRefreshFooter
{
    [self.tableView addSubview:self.refreshFooterView];
    self.reloadingFooter = NO;
}

- (void)createRefreshHeader
{
    EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] 
                                       initWithFrame:CGRectMake(0.0f, 
                                                                0.0f - self.tableView.bounds.size.height, 
                                                                320.0f, 
                                                                self.tableView.bounds.size.height)];
    self.refreshHeaderView = view;
    [view release];
    self.refreshHeaderView.backgroundColor = [UIColor colorWithRed:226.0/255.0 
                                                             green:231.0/255.0 
                                                              blue:237.0/255.0 
                                                             alpha:1.0];
}

- (void)createRefreshFooter
{
    EGORefreshTableFooterView *view = [[EGORefreshTableFooterView alloc] 
                                       initWithFrame:CGRectMake(0.0f, 
                                                                [self tableViewHeight], 
                                                                320.0f, 
                                                                600.0f)];
    self.refreshFooterView = view;
    [view release];
    self.refreshFooterView.backgroundColor = [UIColor colorWithRed:226.0/255.0 
                                                             green:231.0/255.0 
                                                              blue:237.0/255.0 
                                                             alpha:1.0];
    self.refreshFooterView.pullingLabelText = @"Pull up to get older posts";
    self.refreshFooterView.releaseLabelText = @"Release to get older posts";
    [self.refreshFooterView setState:EGOOPullRefreshNormal];
}

- (float)tableViewHeight 
{
    // calculate height of table view (modify for multiple sections)
    float currentHeight = self.tableView.rowHeight * [self tableView:self.tableView numberOfRowsInSection:0];
    if (currentHeight < 431.0f)
        return 431.0f;
    return currentHeight;
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
        [self repositionRefreshViews];
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

- (PostDetailsController*)allocDetailsViewController
{
    return [[PostDetailsController alloc] initWithNibName:@"PostDetailsController" bundle:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostDetailsController *imageDetailViewController = [self allocDetailsViewController];
    
    imageDetailViewController.title     = [self.dataManager getTitleOfPostAtIndex:indexPath];
    imageDetailViewController.postId    = [self.dataManager getPostIdAtIndex:indexPath];
    
    [self.navigationController pushViewController:imageDetailViewController animated:YES];
    [imageDetailViewController release];
}

- (void)reloadTableViewDataSource
{
    [self.dataManager refreshFromWeb:self];
}

- (void)getOlderDataSource
{
    [self.dataManager getOlderFromWeb:self];
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
	[self dataSourceDidFinishLoadingNewData];
}

#pragma mark -
#pragma mark EGORefreshTable Methods

- (void)updateRefreshHeaderWhenScrollDidScroll:(UIScrollView *)scrollView
{
    if (self.refreshHeaderView == nil)
        return;
    
    if (self.refreshHeaderView.state == EGOOPullRefreshPulling && 
        scrollView.contentOffset.y > -65.0f && 
        scrollView.contentOffset.y < 0.0f && 
        !self.reloadingHeader) 
    {
        [self.refreshHeaderView setState:EGOOPullRefreshNormal];
    } 
    else if (self.refreshHeaderView.state == EGOOPullRefreshNormal && 
             scrollView.contentOffset.y < -65.0f && 
             !self.reloadingHeader) 
    {
        [self.refreshHeaderView setState:EGOOPullRefreshPulling];
    }
}

- (void)updateRefreshFooterWhenScrollDidScroll:(UIScrollView *)scrollView
{
    if (self.refreshFooterView == nil)
        return;
    
    float endOfTable = [self endOfTableView:scrollView];
    if (self.refreshFooterView.state == EGOOPullRefreshPulling && 
        endOfTable < 0.0f && 
        endOfTable > -65.0f && 
        !self.reloadingFooter) 
    {
        [self.refreshFooterView setState:EGOOPullRefreshNormal];
    } 
    else if (self.refreshFooterView.state == EGOOPullRefreshNormal 
             && endOfTable < -65.0f && 
             !self.reloadingFooter) 
    {
        [self.refreshFooterView setState:EGOOPullRefreshPulling];
    }
}

- (void)updateRefreshViewsWhenScrollDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.isDragging) 
    {
		[self updateRefreshHeaderWhenScrollDidScroll:scrollView];
        [self updateRefreshFooterWhenScrollDidScroll:scrollView];
	}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{		
    [self updateRefreshViewsWhenScrollDidScroll:scrollView];
}

- (void)updateRefreshHeaderWhenScrollEndDragging:(UIScrollView *)scrollView
{
    if (self.refreshHeaderView == nil)
        return;
    
    if (scrollView.contentOffset.y <= - 65.0f && !self.reloadingHeader) 
    {
        self.reloadingHeader = YES;
        [self reloadTableViewDataSource];
        [self.refreshHeaderView setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
	}
}

- (void)updateRefreshFooterWhenScrollEndDragging:(UIScrollView *)scrollView
{
    if (self.refreshFooterView == nil)
        return;
    
    if ([self endOfTableView:scrollView] <= -65.0f && !self.reloadingFooter) 
    {
        self.reloadingFooter = YES;
        [self getOlderDataSource];
        [self.refreshFooterView setState:EGOOPullRefreshLoading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 60.0f, 0.0f);
        [UIView commitAnimations];
	}
}

- (void)updateRefreshViewsWhenScrollEndDragging:(UIScrollView *)scrollView
{
    [self updateRefreshHeaderWhenScrollEndDragging:scrollView];
    [self updateRefreshFooterWhenScrollEndDragging:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	
    [self updateRefreshViewsWhenScrollEndDragging:scrollView];
}

- (void)dataSourceDidFinishLoadingNewData
{
	self.reloadingHeader = NO;
    self.reloadingFooter = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
    if ([self.refreshHeaderView state] != EGOOPullRefreshNormal) 
    {
        [self.refreshHeaderView setState:EGOOPullRefreshNormal];
        [self.refreshHeaderView setCurrentDate];  //  should check if data reload was successful 
    }
    
    if ([self.refreshFooterView state] != EGOOPullRefreshNormal) 
    {
        [self.refreshFooterView setState:EGOOPullRefreshNormal];
        [self.refreshFooterView setCurrentDate];  //  should check if data reload was successful 
    }
    
    [self repositionRefreshViews];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)repositionRefreshViews 
{
    self.refreshFooterView.center = CGPointMake(160.0f, [self tableViewHeight] + 300.0f);
    [self.refreshFooterView setNeedsDisplay];
}

- (float)endOfTableView:(UIScrollView *)scrollView 
{
    return [self tableViewHeight] - scrollView.bounds.size.height - scrollView.bounds.origin.y;
}

- (void)reloadViewData 
{
    [self.tableView reloadData];
    [self doneLoadingTableViewData];
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
    self.refreshFooterView = nil;
    self.dataManager = nil;
    [super dealloc];
}


@end

