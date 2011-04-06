//
//  PostDetailsController.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/16/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

@class DataManager;
@class GDImagePost;
@class WebView;

@interface PostDetailsController : UITableViewController <UIWebViewDelegate> {
@private
    DataManager *_dataManager;
    int _dataType;
    NSString *_postId;    
    
    UITableViewCell *_imagesCell;
    UITableViewCell *_descriptionCell;
    UITableViewCell *_favoriteCell;
    UITableViewCell *_commentsCell;
    
    UIScrollView *_scrollView;
    UIPageControl *_pageControll;
    UIActivityIndicatorView *_imagesLoadingIndicator;
    
    int _imageCellHeight;
    int _favoriteCellHeight;
    int _descCellHeight;
    int _commentsCellHeight;
    
    WebView *_webView;
    
    UITableView *_tableView;
    
    BOOL _isDataLoaded;
}

@property (nonatomic, retain) DataManager *dataManager;
@property (assign, nonatomic) int dataType;
@property (nonatomic, retain) NSString *postId;
@property (nonatomic, retain) UITableViewCell *descriptionCell;
@property (nonatomic, retain) UITableViewCell *favoriteCell;
@property (nonatomic, retain) UITableViewCell *imagesCell;
@property (nonatomic, retain) UITableViewCell *commentsCell;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControll;
@property (nonatomic, retain) UIActivityIndicatorView *imagesLoadingIndicator;
@property (nonatomic, retain) WebView *webView;


- (void)updateView:(GDImagePost*)post;

@end
