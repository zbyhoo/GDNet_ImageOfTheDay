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
@class GDPicture;
@class ImagesListViewController;
@class Posts;

@interface DataManager : NSObject {
@private
    DBHelper *_dbHelper;
    Posts *_posts;
    int _downloadingDataCounter;
    
    NSObject<GDDataConverter> *_converter;
}

@property (retain, nonatomic) Posts *posts;
@property (retain, nonatomic) DBHelper *dbHelper;
@property (retain, nonatomic) NSObject<GDDataConverter> *converter;

- (id)initWithDbHelper:(DBHelper*)dbHelper;
- (id)init;

- (void)refreshFromWeb:(ImagesListViewController*)view;
- (void)getOlderFromWeb:(ImagesListViewController*)view;
- (void)preloadData:(ImagesListViewController*)view;
- (NSUInteger)postsCount;
- (void)markDeleted:(NSIndexPath*)position;
- (void)permanentlyDeletePost:(NSIndexPath*)position;
- (void)addToFavourites:(NSIndexPath*)position;
- (void)removeFromFavorites:(NSIndexPath*)position;
- (void)refresh:(ImagesListViewController*)view;
- (void)refreshFromWeb:(ImagesListViewController*)view;

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


- (NSPredicate*)getPredicateWithDeleted:(BOOL)deleted;
- (BOOL)shouldDownloadData;
- (BOOL)downloadLargeImage:(GDPicture*)picture;

- (void)dataDownloadStarted;
- (void)dataDownloadEnded;

@end
