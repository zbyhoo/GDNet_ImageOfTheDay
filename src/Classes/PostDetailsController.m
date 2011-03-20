//
//  PostDetailsController.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/16/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "PostDetailsController.h"
#import "DataManager.h"
#import "DBHelper.h"
#import "GDArchiveHtmlStringConverter.h"
#import "ImagesViewCell.h"
#import "DescriptionViewCell.h"
#import "GDImagePost.h"
#import "GDPicture.h"

int imageCellHeight = 100;

@interface PostDetailsController (Private)

- (UITableViewCell*)getImagesCell:(UITableView*)tableView;
- (UITableViewCell*)getDescriptionCell:(UITableView*)tableView;

@end

@implementation PostDetailsController

typedef enum {
    SECTION_IMAGES,
    SECTION_DESCRIPTION,
    
    SECTION_COUNT
} Sections;

@synthesize dataManager = _dataManager;
@synthesize postId = _postId;
@synthesize imagesCell = _imagesCell;
@synthesize descriptionCell = _descriptionCell;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    _dataManager = [[DataManager alloc] init];
    [_dataManager getPostInfoWithView:self];
}

- (void)viewDidUnload
{
    self.dataManager = nil;
    self.postId = nil;
    self.imagesCell = nil;
    self.descriptionCell = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return SECTION_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case SECTION_IMAGES:
            cell = [self getImagesCell:tableView];
            break;
        case SECTION_DESCRIPTION:
            cell = [self getDescriptionCell:tableView];
            break;
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell*)getImagesCell:(UITableView*)tableView {
    
    if (self.imagesCell == nil) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, imageCellHeight);
        self.imagesCell = cell;
        [cell release];
    }
    
    return self.imagesCell;
}

- (void)updateImagesCell:(GDImagePost*)post {

    UITableViewCell *cell = [self getImagesCell:self.tableView];
    
    
    int imageSpacing = 4;
    int imageWidth = cell.frame.size.width - 30 - imageSpacing;
    float imageRatio = 3.0f / 4.0f;
    int imageHeight = imageWidth * imageRatio;
    
    CGRect frame = CGRectMake(5, 5, imageWidth + imageSpacing, imageHeight + imageSpacing);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:frame];
    
    int imageCount = 0;
    for (GDPicture *picture in post.pictures) {
        if (picture.smallPictureData) {
            UIImage *image = [[UIImage alloc] initWithData:picture.smallPictureData];
            
            
            int currentPosition = (imageSpacing / 2) + (imageCount * (imageWidth + imageSpacing));
            CGRect imageFrame = CGRectMake(currentPosition, imageSpacing / 2, imageWidth, imageHeight);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
            imageView.image = image;
            [scrollView addSubview:imageView];
            [imageView release];
            [image release];
            
            ++imageCount;
        }
    }        
    
    int totalWidth = (imageSpacing + imageWidth) * imageCount;
    LogDebug(@"Images Loaded: %d", imageCount);
    
    scrollView.contentSize = CGSizeMake(totalWidth, imageHeight + imageSpacing);
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor blackColor];
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = YES;
    scrollView.scrollEnabled = YES;
    scrollView.tag = 1;
    scrollView.delegate = self;
    _scrollView = scrollView;
    [[cell contentView] addSubview:scrollView];
    imageCellHeight = scrollView.frame.size.height + 10;
    
    // add page view
    CGRect pageFrame = CGRectMake(5, scrollView.frame.size.height + 5, scrollView.frame.size.width, 20);
    UIPageControl *pageControll = [[UIPageControl alloc] initWithFrame:pageFrame];
    pageControll.numberOfPages = imageCount;
    pageControll.tag = 2;
    pageControll.backgroundColor = [UIColor blackColor];
    _pageControll = pageControll;
    [[cell contentView] addSubview:pageControll];
    imageCellHeight += pageControll.frame.size.height;
    
    cell.backgroundColor = [UIColor blackColor];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = _scrollView.frame.size.width;
    int currentPage = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageControll.currentPage = currentPage;
}


- (UITableViewCell*)getDescriptionCell:(UITableView*)tableView {
    static NSString *cellIdentifier = @"DescCell";
    DescriptionViewCell *cell = (DescriptionViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[DescriptionViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
    }
    
    // TODO set values and resize cell and table row
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // TODO set proper size
    switch (indexPath.section) {
        case SECTION_IMAGES:        return imageCellHeight;
        case SECTION_DESCRIPTION:   return 100.0f;
        default:                    return 0.0f;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case SECTION_IMAGES:        return @"Images";
        case SECTION_DESCRIPTION:   return @"Description";
        default:                    return @"";
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType; 
{
    NSURL *requestURL =[ [ request URL ] retain ]; 
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ]) 
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) { 
        return ![ [ UIApplication sharedApplication ] openURL: [ requestURL autorelease ] ]; 
    } 
    [ requestURL release ]; 
    return YES; 
}

- (void)updateView:(GDImagePost*)post {
    //[self.descriptionView loadHTMLString:post.postDescription baseURL:nil];
    [self updateImagesCell:post];
    
    // to resize rows
    //[self.tableView beginUpdates];
    //[self.tableView endUpdates];
    [self.tableView reloadData];
}

@end
