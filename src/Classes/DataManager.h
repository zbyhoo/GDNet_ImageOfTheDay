//
//  DataManager.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ImagesListViewController.h"
#import "GDDataConverter.h"
#import "IOTDTableViewCell.h"

@interface DataManager : NSObject {
@private
    NSManagedObjectContext *managedObjectContext_;
    NSMutableArray *_posts;
    NSObject<GDDataConverter> *_converter;
}

@property (assign) NSManagedObjectContext *managedObjectContext;
@property (retain) NSObject<GDDataConverter> *converter;

+ (DataManager*) instance;
+ (void) destoryInstance;

- (void) preloadData;
- (NSUInteger) postsCount;
- (void) setPosts:(NSMutableArray*)newPosts;
- (void) updatePostAtIndex:(NSIndexPath*)indexPath cell:(IOTDTableViewCell*)cell view:(ImagesListViewController*)view;
- (void) deletePost:(NSUInteger)position;

- (void) refreshFromWeb:(UITableView*)view;

@end
