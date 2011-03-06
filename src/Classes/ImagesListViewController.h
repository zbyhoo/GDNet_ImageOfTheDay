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

@interface ImagesListViewController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet TableViewCell *tblCell;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

- (void)reloadCellAtIndexPath:(NSIndexPath*)indexPath;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
