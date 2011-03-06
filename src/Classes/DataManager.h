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
#import "TableViewCell.h"

@interface DataManager : NSObject {
@private
    NSManagedObjectContext *_managedObjectContext;
    NSMutableArray *_posts;
    NSObject<GDDataConverter> *_converter;
}

@property (assign) NSManagedObjectContext *managedObjectContext;
@property (retain) NSObject<GDDataConverter> *converter;
@property (retain) NSMutableArray *posts;

+ (DataManager*) instance;
+ (void) destoryInstance;

- (void) preloadData:(UITableView*)view;
- (NSUInteger) postsCount;
- (void) updatePostAtIndex:(NSIndexPath*)indexPath cell:(TableViewCell*)cell view:(ImagesListViewController*)view;
- (void) deletePost:(NSUInteger)position;

- (void) refreshFromWeb:(UITableView*)view;
- (NSMutableArray*)fetchPostsWithPredicate:(NSPredicate*)predicate;

@end
