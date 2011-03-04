//
//  ImagesListViewController.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/26/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"

@interface ImagesListViewController : UITableViewController {
    IBOutlet TableViewCell *tblCell;
}

- (void)reloadCellAtIndexPath:(NSIndexPath*)indexPath;

@end
