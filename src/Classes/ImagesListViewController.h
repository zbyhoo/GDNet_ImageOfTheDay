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

@interface ImagesListViewController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet TableViewCell *tblCell;
    
@private
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    int _dataType;
    DataManager *_dataManager;
}

@property (retain, nonatomic) DataManager *dataManager;

- (void)reloadCellAtIndexPath:(NSIndexPath*)indexPath;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (void)setDataType:(int)type;

@end
