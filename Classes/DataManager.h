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

@interface DataManager : NSObject {
@private
    NSManagedObjectContext *managedObjectContext_;
    NSMutableArray *_posts;
}

@property (assign) NSManagedObjectContext *managedObjectContext;

+ (DataManager*) instance;
+ (void) destoryInstance;

- (void) preloadData;
- (NSUInteger) postsCount;
- (void) updatePostAtIndex:(NSIndexPath*)indexPath cell:(UITableViewCell*)cell view:(ImagesListViewController*)view;
- (void) deletePost:(NSUInteger)position;

@end
