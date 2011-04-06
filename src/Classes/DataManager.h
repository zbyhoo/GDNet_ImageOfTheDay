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
@property (assign, nonatomic) int dataType;

- (id)initWithDataType:(int)type 
              dbHelper:(DBHelper*)dbHelper;
- (id)initWithDataType:(int)type;
- (id)init;

- (void)refreshFromWeb:(UITableView*)view;
- (void)preloadData:(UITableView*)view;
- (NSUInteger)postsCount;
- (void)markDeleted:(NSIndexPath*)position;
- (void)permanentlyDeletePost:(NSIndexPath*)position;
- (void)addToFavourites:(NSIndexPath*)position;
- (void)removeFromFavorites:(NSIndexPath*)position;
- (void)refresh:(UITableView*)view;
- (void)refreshFromWeb:(UITableView*)view;

- (void)getPostInfoWithView:(PostDetailsController*)view;
- (NSString*)getTitleOfPostAtIndex:(NSIndexPath*)indexPath;
- (NSString*)getPostIdAtIndex:(NSIndexPath*)indexPath;
- (GDImagePost*)getPostAtIndex:(NSIndexPath*)indexPath;
- (GDImagePost*)getPostWithId:(NSString*)postId;

- (NSSortDescriptor*)getDateSortDescriptor;
- (NSPredicate*)getPredicateWithDeleted:(BOOL)deleted;
- (BOOL)shouldDownloadData;

- (BOOL)addPostToFavourites:(GDImagePost*)post;
- (BOOL)removePostFromFavorites:(GDImagePost*)post;

@end
