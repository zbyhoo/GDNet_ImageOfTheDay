//
//  DataManager.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GDDataConverter.h"

@class ImagesListViewController;
@class TableViewCell;

@interface DataManager : NSObject {
@private
    NSMutableArray *_posts;
    int _dataType;
}

@property (retain) NSMutableArray *posts;

- (id)initWithDataType:(int)type;

- (void)refreshFromWeb:(UITableView*)view;

- (void)preloadData:(UITableView*)view;
- (NSUInteger)postsCount;
- (void)updatePostAtIndex:(NSIndexPath*)indexPath cell:(TableViewCell*)cell view:(ImagesListViewController*)view;
- (void)deletePost:(NSIndexPath*)position permanent:(BOOL)permanent;
- (void)addToFavourites:(NSIndexPath*)position view:(UITableView*)view;

- (void)refresh:(UITableView*)view;
- (void)refreshFromWeb:(UITableView*)view;
- (NSMutableArray*)fetchPostsWithPredicate:(NSPredicate*)predicate sorting:(NSSortDescriptor*)sorting;

+ (void)setManagedContext:(NSManagedObjectContext*)context;
+ (void)setConverter:(NSObject<GDDataConverter>*)converter;

@end
