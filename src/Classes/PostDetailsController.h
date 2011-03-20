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
    NSString *_postId;    
    
    IBOutlet UITableViewCell *_imagesCell;
    IBOutlet UITableViewCell *_descriptionCell;
    
    UIScrollView *_scrollView;
    UIPageControl *_pageControll;
    UIActivityIndicatorView *_imagesLoadingIndicator;
    
    int _imageCellHeight;
    int _descCellHeight;
    
    WebView *_webView;
}

@property (nonatomic, retain) DataManager *dataManager;
@property (nonatomic, retain) NSString *postId;
@property (nonatomic, retain) UITableViewCell *descriptionCell;
@property (nonatomic, retain) UITableViewCell *imagesCell;

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIPageControl *pageControll;
@property (nonatomic, retain) UIActivityIndicatorView *imagesLoadingIndicator;
@property (nonatomic, retain) WebView *webView;


- (void)updateView:(GDImagePost*)post;

@end
