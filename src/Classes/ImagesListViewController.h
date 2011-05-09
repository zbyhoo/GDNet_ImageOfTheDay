//
//  ImagesListViewController.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/26/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

@class TableViewCell;
@class DataManager;
@class PostDetailsController;
@class EGORefreshTableHeaderView;
@class EGORefreshTableFooterView;

@interface ImagesListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet TableViewCell *tblCell;
    
@private
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    BOOL _reloadingHeader;
    BOOL _reloadingFooter;
    
    DataManager *_dataManager;
}

@property (retain) DataManager *dataManager;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, retain) EGORefreshTableFooterView *refreshFooterView;
@property (nonatomic, assign) BOOL reloadingHeader;
@property (nonatomic, assign) BOOL reloadingFooter;

- (void)setupNavigationButtons;
- (void)setupRefreshHeaderAndFooter;
- (void)setupDataManager;
- (PostDetailsController*)allocDetailsViewController;

- (void)reloadCellAtIndexPath:(NSIndexPath*)indexPath;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)reloadViewData;

@end
