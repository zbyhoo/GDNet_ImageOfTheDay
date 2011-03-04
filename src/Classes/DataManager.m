//
//  DataManager.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "DataManager.h"
#import "Constants.h"

//@interface PostUpdateData : NSObject {
//@public
//    NSIndexPath *_indexPath;
//    UITableViewCell *_cell;
//    ImagesListViewController *_view;
//}
//@property (retain) NSIndexPath *indexPath;
//@property (retain) UITableViewCell *cell;
//@property (retain) ImagesListViewController *view;
//@end
//@implementation PostUpdateData
//@synthesize indexPath = _indexPath;
//@synthesize cell = _cell;
//@synthesize view = _view;
//@end




@implementation DataManager

#pragma mark -
#pragma mark Instance stuff

static DataManager* _dataManager = nil;

@synthesize managedObjectContext = managedObjectContext_;
@synthesize converter = _converter;

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
                    LogError(@"unable to create DataManager object");
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

- (id) init
{
    if ([super init] != nil)
    {
        self.converter = nil;
    }
    else
    {
        LogError(@"initialization of parent class (%@) failed", super.class);
    }
    return self;
}

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
            LogInfo(@"creating instance of DataManager"); 
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
        LogInfo(@"removing old stuff");
        [_posts release];
    }
    _posts = [[NSMutableArray alloc] init];
    
    //TODO loads data from core data storage to array if neccessary ???
}

- (NSUInteger)postsCount    { return _posts.count; }

- (void) updatePostAtIndex:(NSIndexPath*)indexPath cell:(TableViewCell*)cell view:(ImagesListViewController*)view;
{
    //TODO
    //PostUpdateData* postUpdateData = [[PostUpdateData alloc] init];
    //postUpdateData.indexPath = indexPath;
    //postUpdateData.cell = cell;
    //postUpdateData.view = view;
    
    //[postUpdateData release];
        
    cell.titleLabel.text = [[_posts objectAtIndex:indexPath.row] valueForKey:KEY_TITLE];
}

- (void) deletePost:(NSUInteger)position {
    //TODO delete from database (mark as deleted, but not delete if is in favourites)
}

- (void) setPosts:(NSMutableArray*)newPosts {
    NSLog(@"setting posts");
    [_posts release];
    _posts = [newPosts retain];
}

- (void) downloadData:(UITableView*)view {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSArray *webPosts = [_converter convertGallery:GD_ARCHIVE_IOTD_PAGE_URL];
    [self performSelectorOnMainThread:@selector(setPosts:) withObject:webPosts waitUntilDone:YES];
    [view reloadData];
    
    [pool drain];
}

- (void) refreshFromWeb:(UITableView*)view {
    
    if (_posts.count == 0) {
        [NSThread detachNewThreadSelector:@selector(downloadData:) toTarget:self withObject:view];
    }

    //TODO verify if retrived posts are already in core data 
}

@end
