//
//  DataManager.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "GDDataConverter.h"


@class TableViewCell;
@class DBHelper;
@class PostDetailsController;
@class GDImagePost;

@interface DataManager : NSObject {
@private
    DBHelper *_dbHelper;
    NSMutableArray *_posts;
    int _dataType;
}

@property (retain, nonatomic) NSMutableArray *posts;
@property (retain, nonatomic) DBHelper *dbHelper;

- (id)initWithDataType:(int)type 
              dbHelper:(DBHelper*)dbHelper;
- (id)initWithDataType:(int)type;
- (id)init;

- (void)refreshFromWeb:(UITableView*)view;
- (void)preloadData:(UITableView*)view;
- (NSUInteger)postsCount;
- (void)deletePost:(NSIndexPath*)position permanent:(BOOL)permanent;
- (void)addToFavourites:(NSIndexPath*)position view:(UITableView*)view;
- (void)refresh:(UITableView*)view;
- (void)refreshFromWeb:(UITableView*)view;

- (void)getPostInfoWithView:(PostDetailsController*)view;
- (NSString*)getTitleOfPostAtIndex:(NSIndexPath*)indexPath;
- (NSString*)getPostIdAtIndex:(NSIndexPath*)indexPath;
- (GDImagePost*)getPostAtIndex:(NSIndexPath*)indexPath;

@end
