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
@class DBHelper;
//@class ImageDetailViewController;
@class PostDetailsController;


@interface DataManager : NSObject {
@private
    DBHelper *_dbHelper;
    NSObject<GDDataConverter>* _converter;
    NSMutableArray *_posts;
    int _dataType;
}

@property (retain, nonatomic) NSMutableArray *posts;
@property (retain, nonatomic) DBHelper *dbHelper;
@property (retain, nonatomic) NSObject<GDDataConverter>* converter;

- (id)initWithDataType:(int)type 
              dbHelper:(DBHelper*)dbHelper 
             converter:(NSObject<GDDataConverter>*)converter;

- (id)initWithDbHelper:(DBHelper*)dbHelper 
             converter:(NSObject<GDDataConverter>*)converter;

- (void)refreshFromWeb:(UITableView*)view;
- (void)preloadData:(UITableView*)view;
- (NSUInteger)postsCount;
- (void)updatePostAtIndex:(NSIndexPath*)indexPath 
                     cell:(TableViewCell*)cell 
                     view:(ImagesListViewController*)view;
- (void)deletePost:(NSIndexPath*)position permanent:(BOOL)permanent;
- (void)addToFavourites:(NSIndexPath*)position view:(UITableView*)view;
- (void)refresh:(UITableView*)view;
- (void)refreshFromWeb:(UITableView*)view;

- (void)getPostInfoWithView:(PostDetailsController*)view;
- (NSString*)getTitleOfPostAtIndex:(NSIndexPath*)indexPath;
- (NSString*)getPostIdAtIndex:(NSIndexPath*)indexPath;

@end
