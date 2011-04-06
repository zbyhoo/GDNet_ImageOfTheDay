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
#import "GDImagePost.h"
#import "GDPicture.h"
#import "WebView.h"
#import "ImageButton.h"
#import "ZoomedImageViewController.h"

@interface PostDetailsController (Private)

- (UITableViewCell*)getImagesCell:(UITableView*)tableView;
- (UITableViewCell*)getDescriptionCell:(UITableView*)tableView;
- (UITableViewCell*)getFavoriteCell:(UITableView*)tableView;
- (UITableViewCell*)getCommentsCell:(UITableView*)tableView;

@end

@implementation PostDetailsController

typedef enum {
    SECTION_IMAGES,
    SECTION_FAVORITE,
    SECTION_DESCRIPTION,
    SECTION_COMMENTS,
    
    SECTION_COUNT
} Sections;

@synthesize dataManager     = _dataManager;
@synthesize dataType        = _dataType;
@synthesize postId          = _postId;

@synthesize imagesCell      = _imagesCell;
@synthesize favoriteCell    = _favoriteCell;
@synthesize descriptionCell = _descriptionCell;
@synthesize commentsCell    = _commentsCell;

@synthesize scrollView      = _scrollView;
@synthesize pageControll    = _pageControll;
@synthesize imagesLoadingIndicator = _imagesLoadingIndicator;
@synthesize webView         = _webView;

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
    self.dataManager = nil;
    self.postId = nil;
    self.imagesCell = nil;
    self.favoriteCell = nil;
    self.descriptionCell = nil;
    self.commentsCell = nil;
    self.scrollView = nil;
    self.pageControll = nil;
    self.imagesLoadingIndicator = nil;
    self.webView = nil;
    
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

    _imageCellHeight = 40;
    _favoriteCellHeight = 30;
    _descCellHeight = 20;
    _commentsCellHeight = 30;
    
    _isDataLoaded = NO;
    
    _dataManager = [[DataManager alloc] initWithDataType:self.dataType];
    [_dataManager getPostInfoWithView:self];
}

- (void)viewDidUnload
{
    self.dataManager        = nil;
    self.postId             = nil;
    self.imagesCell         = nil;
    self.descriptionCell    = nil;
    self.scrollView         = nil;
    self.pageControll       = nil;
    self.imagesLoadingIndicator = nil;
    self.webView            = nil;
    
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _isDataLoaded ? SECTION_COUNT : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isDataLoaded ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case SECTION_IMAGES:
            cell = [self getImagesCell:tableView];
            break;
        case SECTION_FAVORITE:
            cell = [self getFavoriteCell:tableView];
            break;
        case SECTION_DESCRIPTION:
            cell = [self getDescriptionCell:tableView];
            break;
        case SECTION_COMMENTS:
            cell = [self getCommentsCell:tableView];
            break;
        default:
            break;
    }
    
    return cell;
}

- (UITableViewCell*)getImagesCell:(UITableView*)tableView {
    
    if (self.imagesCell == nil) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, _imageCellHeight);
        cell.backgroundColor = [UIColor blackColor];
        
        int indicatorSize = 20;
        CGRect indicatorFrame = CGRectMake(cell.frame.size.width / 2 - indicatorSize,
                                           cell.frame.size.height / 2 - indicatorSize / 2,
                                           indicatorSize,
                                           indicatorSize);
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:indicatorFrame];
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
        self.imagesLoadingIndicator = activityIndicatorView;
        [self.imagesLoadingIndicator startAnimating];
        [cell.contentView addSubview:self.imagesLoadingIndicator];
        
        [activityIndicatorView startAnimating];
        
        self.imagesCell = cell;
        self.imagesCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell release];
    }
    
    return self.imagesCell;
}

- (void)imageButtonClick:(id)sender {
    ImageButton *button = (ImageButton*)sender;
    
    if (button.picture.largePictureData == nil) {
        LogError(@"no data for picture for url: %@", button.picture.largePictureUrl);
        return;
    }
    
    LogDebug(@"clicked - img url: %@", button.picture.largePictureUrl);
    
    UIImage *image = [[UIImage alloc] initWithData:button.picture.largePictureData];
    ZoomedImageViewController *zoomedImageView = [[ZoomedImageViewController alloc] initWithImage:image];
    [image release];
    [self.navigationController pushViewController:zoomedImageView animated:YES];
    [zoomedImageView release];
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
            
            ImageButton *button = [[ImageButton buttonWithType:UIButtonTypeCustom] retain];
            button.frame = imageFrame;
            button.bounds = CGRectMake(0, 0, imageFrame.size.width, imageFrame.size.height);
            [button setBackgroundImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.picture = picture;
            [scrollView addSubview:button];
            
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
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = YES;
    scrollView.scrollEnabled = YES;
    scrollView.tag = 1;
    scrollView.delegate = self;
    self.scrollView = scrollView;
    [scrollView release];
    [[cell contentView] addSubview:scrollView];
    _imageCellHeight = scrollView.frame.size.height + 10;
    
    // add page view
    CGRect pageFrame = CGRectMake(5, scrollView.frame.size.height + 5, scrollView.frame.size.width, 20);
    UIPageControl *pageControll = [[UIPageControl alloc] initWithFrame:pageFrame];
    pageControll.numberOfPages = imageCount;
    pageControll.tag = 2;
    pageControll.backgroundColor = [UIColor blackColor];
    pageControll.userInteractionEnabled = NO;
    self.pageControll = pageControll;
    [[cell contentView] addSubview:pageControll];
    _imageCellHeight += pageControll.frame.size.height;
    
    cell.backgroundColor = [UIColor blackColor];
    [self.imagesLoadingIndicator stopAnimating];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int currentPage = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControll.currentPage = currentPage;
}


- (UITableViewCell*)getDescriptionCell:(UITableView*)tableView {
    
    if (self.descriptionCell == nil) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        self.descriptionCell = cell;
        self.descriptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell release];
        
        _tableView = tableView;
    }
    
    return self.descriptionCell;
}

- (void)updateDescriptionCell:(GDImagePost*)post {
    
    UITableViewCell *cell = [self getDescriptionCell:self.tableView];
    
    CGRect webFrame = CGRectMake(5, 5, cell.frame.size.width - 30, _descCellHeight - 10);
    WebView *webView = [[WebView alloc] initWithFrame:webFrame];
    webView.delegate = self;
    
    NSString *pageWidht = [NSString stringWithFormat:@"<html><body><div style=\"width: %dpx; word-wrap: break-word\">", 275];
    NSString *content = [NSString stringWithFormat:@"%@%@%@", pageWidht, post.postDescription, @"</div></body></html>"];
    [webView loadHTMLString:content baseURL:nil];
    
    _descCellHeight = webView.frame.size.height + 10;
    self.webView = webView;
    [webView release];
    self.webView.scalesPageToFit = NO;
    self.webView.multipleTouchEnabled = NO;
    [cell.contentView addSubview:self.webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    
    int contentHeight = [[self.webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"] intValue];
    LogDebug(@"content height: %d", contentHeight);
    contentHeight += 10;
    self.webView.frame = CGRectMake(5, 5, self.webView.frame.size.width, contentHeight);
    _descCellHeight = contentHeight + 10;
    CGRect frame = self.descriptionCell.frame;
    frame.size.height = _descCellHeight;
    self.descriptionCell.frame = frame;
    
    for (UIView *view in self.webView.subviews) {
        if ([[view class] isSubclassOfClass:[UIScrollView class]]) {
            ((UIScrollView*)view).scrollEnabled = NO;
        }
    }
    
    [_tableView reloadData];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (UITableViewCell*)getFavoriteCell:(UITableView*)tableView {
    
    if (self.favoriteCell == nil) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        self.favoriteCell = cell;
        self.favoriteCell.backgroundColor = [UIColor blackColor];
        self.favoriteCell.textLabel.textColor = [UIColor whiteColor];
        self.favoriteCell.textLabel.textAlignment = UITextAlignmentCenter;
        self.favoriteCell.selectionStyle = UITableViewCellSelectionStyleGray;
        self.favoriteCell.textLabel.text = (self.dataManager.dataType == POST_NORMAL) ?
                                            @"Add to Favorites" : @"Remove from Favorites";
        [cell release];
    }
    
    return self.favoriteCell;
}

- (UITableViewCell*)getCommentsCell:(UITableView*)tableView {

    if (self.commentsCell == nil) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];
        self.commentsCell = cell;
        self.commentsCell.backgroundColor = [UIColor blackColor];
        self.commentsCell.textLabel.textColor = [UIColor whiteColor];
        self.commentsCell.textLabel.textAlignment = UITextAlignmentCenter;
        self.commentsCell.selectionStyle = UITableViewCellSelectionStyleGray;
        self.commentsCell.textLabel.text = @"Comments (online)";
        [cell release];
    }
    
    return self.commentsCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.section) {
        case SECTION_IMAGES:        return _imageCellHeight;
        case SECTION_FAVORITE:      return _favoriteCellHeight;
        case SECTION_DESCRIPTION:   return _descCellHeight;
        case SECTION_COMMENTS:      return _commentsCellHeight;
        default:                    return 0.0f;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case SECTION_IMAGES:        return @"Images";
        case SECTION_FAVORITE:      return @"";
        case SECTION_DESCRIPTION:   return @"Description";
        case SECTION_COMMENTS:      return @"";
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

- (void)favoriteButtonSelected {
    
    GDImagePost *post = [self.dataManager getPostWithId:_postId];
    
    if (self.dataManager.dataType == POST_NORMAL)
        [self.dataManager addPostToFavourites:post];
    else if (self.dataManager.dataType == POST_FAVOURITE)
        [self.dataManager removePostFromFavorites:post];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    switch (indexPath.section) 
    {
        case SECTION_FAVORITE:
            [self favoriteButtonSelected];
            break;
            
        default:
            break;
    }
    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType; 
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

    _isDataLoaded = YES;
    [self.tableView reloadData];
    
    [self updateImagesCell:post];
    [self updateDescriptionCell:post];
    
    [self.tableView reloadData];
}

@end
