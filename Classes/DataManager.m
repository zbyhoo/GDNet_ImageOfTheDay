//
//  DataManager.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "DataManager.h"

@interface PostUpdateData : NSObject {
@public
    NSIndexPath *_indexPath;
    UITableViewCell *_cell;
    ImagesListViewController *_view;
}
@property (retain) NSIndexPath *indexPath;
@property (retain) UITableViewCell *cell;
@property (retain) ImagesListViewController *view;
@end
@implementation PostUpdateData
@synthesize indexPath = _indexPath;
@synthesize cell = _cell;
@synthesize view = _view;
@end




@implementation DataManager

#pragma mark -
#pragma mark Instance stuff

static DataManager* _dataManager = nil;

@synthesize managedObjectContext = managedObjectContext_;

+ (DataManager*) instance
{
    if (_dataManager == nil)
    {
        @synchronized(self)
        {
            if (_dataManager == nil)
            {
                _dataManager = [[super allocWithZone:NULL] init];
                if (_dataManager == nil)
                {
                    //TODO error handling
                    return nil;
                }
                [_dataManager preloadData];
            }
        }
    }
    return _dataManager;
}

+ (id) allocWithZone:(NSZone *)zone { return [self instance]; }

- (id) copyWithZone:(NSZone *)zone  { return self; }

- (id) retain                       { return self; }

- (NSUInteger) retainCount          { return NSUIntegerMax; }

- (void) release                    { /* do nothing */ }

- (id) autorelease                  { return self; }

+ (void) destoryInstance
{
    if (_dataManager != nil)
    {
        @synchronized(self)
        {
            if (_dataManager != nil)
            {
                [_dataManager dealloc];
            }
        }
    }
}

- (void) dealloc
{
    //TODO remove all neccessary data here
    // ...
    if (_posts != nil)
    {
        [_posts release];
    }
    
    [super dealloc];
}

#pragma mark -
#pragma mark Business stuff

- (void) preloadData
{
    if (_posts != nil)
    {
        [_posts release];
    }
    _posts = [[NSMutableArray alloc] init];
    
    //TODO loads data from core data storage to array if neccessary ???
}

- (NSUInteger)postsCount    { return _posts.count; }

- (void) loadCellData:(PostUpdateData*)postUpdateData
{
    //TODO update cell
    // ...
    
    [postUpdateData.view performSelectorOnMainThread:@selector(reloadCellAtIndexPath:) withObject:postUpdateData.indexPath waitUntilDone:NO];
}

- (void) updatePostAtIndex:(NSIndexPath*)indexPath cell:(UITableViewCell*)cell view:(ImagesListViewController*)view;
{
    //TODO
    PostUpdateData* postUpdateData = [[PostUpdateData alloc] init];
    postUpdateData.indexPath = indexPath;
    postUpdateData.cell = cell;
    postUpdateData.view = view;
    
    [NSThread detachNewThreadSelector:@selector(loadCellData:) toTarget:self withObject:postUpdateData];
    
    [postUpdateData release];
}

- (void) deletePost:(NSUInteger)position
{
    //TODO delete from database (mark as deleted, but not delete if is in favourites)
}

@end
