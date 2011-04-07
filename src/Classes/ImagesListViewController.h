//
//  ImagesListViewController.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/26/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "EGORefreshTableHeaderView.h"

@class DataManager;
@class PostDetailsController;

@interface ImagesListViewController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet TableViewCell *tblCell;
    
@private
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    DataManager *_dataManager;
}

@property (nonatomic, retain) DataManager *dataManager;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, assign) BOOL reloading;

- (void)setupNavigationButtons;
- (void)setupRefreshHeaderAndFooter;
- (void)setupDataManager;
- (PostDetailsController*)allocDetailsViewController;

- (void)reloadCellAtIndexPath:(NSIndexPath*)indexPath;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
