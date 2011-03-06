//
//  DataManager.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "DataManager.h"
#import "Constants.h"
#import "GDImagePost.h"


@implementation DataManager

#pragma mark -
#pragma mark Instance stuff

static DataManager* _dataManager = nil;

@synthesize managedObjectContext = _managedObjectContext;
@synthesize converter = _converter;
@synthesize posts = _posts;

+ (DataManager*)instance {
    if (_dataManager == nil) {
        @synchronized(self) {
            if (_dataManager == nil) {
                _dataManager = [[super allocWithZone:NULL] init];
                if (_dataManager == nil) {
                    LogError(@"unable to create DataManager object");
                    return nil;
                }
            }
        }
    }
    return _dataManager;
}

+ (id)allocWithZone:(NSZone *)zone { return [self instance]; }
- (id)copyWithZone:(NSZone *)zone  { return self; }

- (id)init {
    if ([super init] != nil) {
        self.converter = nil;
        //_posts = [[self fetchPostsWithPredicate:nil] retain];
    }
    else {
        LogError(@"initialization of parent class (%@) failed", super.class);
    }
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (void)release { 
    // intentionaly left blank - do nothing
}

- (id)autorelease {
    return self;
}

+ (void)destoryInstance {
    if (_dataManager != nil) {
        @synchronized(self) {
            LogInfo(@"creating instance of DataManager"); 
            if (_dataManager != nil) {
                [_dataManager dealloc];
            }
        }
    }
}

- (void)dealloc {
    //TODO remove all neccessary data here
    // ...
    if (_posts != nil) {
        [_posts release];
    }
    
    [super dealloc];
}

#pragma mark -
#pragma mark Business stuff

- (void)preloadData:(UITableView*)view {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"postDate" ascending:NO];
    self.posts = [self fetchPostsWithPredicate:nil sorting:sortDescriptor];
    [sortDescriptor release];
    
    if (self.posts.count == 0) {
        [NSThread detachNewThreadSelector:@selector(downloadData:) toTarget:self withObject:view];
    }
}

- (NSUInteger)postsCount { 
    return self.posts.count; 
}

- (void)updatePostAtIndex:(NSIndexPath*)indexPath cell:(TableViewCell*)cell view:(ImagesListViewController*)view {
    if (indexPath.row >= self.posts.count) {
        LogError(@"index path (%d) greater than number of posts (%d)", indexPath.row, self.posts.count);
        return;
    }
    
    // TODO
    GDImagePost* post = [self.posts objectAtIndex:indexPath.row];
    cell.titleLabel.text = post.title;
    //cell.titleLabel.text = [NSString stringWithFormat:@"%d", post.postDate];
}

- (void)deletePost:(NSIndexPath*)position {
    // TODO check in the future relationships
    [self.managedObjectContext deleteObject:[self.posts objectAtIndex:position.row]];
    NSError* error;
    if (![self.managedObjectContext save:&error]) {
        LogError(@"error deleting object:\n%@", [error userInfo]);
    }
    else {
        [self.posts removeObjectAtIndex:position.row];
    }
}

//- (NSDate*)mostRecentPostDate {
//    
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
//                                        initWithKey:@"postDate" ascending:YES];
//    NSArray* objects = [self fetchPostsWithPredicate:nil sorting:sortDescriptor];
//        [sortDescriptor release];
//    
//    if (objects != nil) {
//        GDImagePost* post = (GDImagePost*)[objects objectAtIndex:0];
//        return post.postDate;
//    }
//    return nil;
//}

- (NSMutableArray*)fetchPostsWithPredicate:(NSPredicate*)predicate sorting:(NSSortDescriptor*)sorting {
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"GDImagePost" inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    if (predicate != nil) {
        [request setPredicate:predicate];
    }
    
    if (sorting != nil) {
        [request setSortDescriptors:[NSArray arrayWithObject:sorting]];
    }
    
    NSError *error = nil;
    NSArray *array = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (array == nil) {
        LogError(@"error fetching request:\n%@", [error userInfo]);
        return nil;
    }
    LogDebug(@"number of posts fetched: %d", [array count]);
    return [NSMutableArray arrayWithArray:array];
}

- (BOOL)existsInDatabase:(NSDictionary*)objectDict {
    NSPredicate *requestPredicate = [NSPredicate 
                                     predicateWithFormat:[NSString stringWithFormat:@"(url like '%@')", [objectDict valueForKey:KEY_POST_URL]]];    
    LogDebug(@"searching core data for: %@", [objectDict valueForKey:KEY_POST_URL]);

    NSArray *array = [self fetchPostsWithPredicate:requestPredicate sorting:nil];
    if (array == nil) {
        LogError(@"nil returned istead of array");
        return NO;
    }
    
    if ([array count] == (NSUInteger)1) {
        return YES;
    }
    else if ([array count] > (NSUInteger)1) {
        LogError(@"many objects found for key: %@", [objectDict valueForKey:KEY_POST_URL]);
    }
    
    return NO;
}

- (void)addNewPost:(GDImagePost*)post {
    GDImagePost *stored;
    NSUInteger index = 0;
    for (stored in self.posts) {
        if ([post.postDate intValue] >= [stored.postDate intValue]) {
            [self.posts insertObject:post atIndex:index];
            return;
        }
        ++index;
    }
    [self.posts addObject:post];
}

- (void)addToDatabase:(NSDictionary*)objectDict {
    // TODO implement
    // add to database and posts
    
    GDImagePost* imagePost = (GDImagePost*)[NSEntityDescription 
                                           insertNewObjectForEntityForName:@"GDImagePost" 
                                           inManagedObjectContext:self.managedObjectContext];
    imagePost.author    = [objectDict valueForKey:KEY_AUTHOR];
    imagePost.title     = [objectDict valueForKey:KEY_TITLE];
    imagePost.url       = [objectDict valueForKey:KEY_POST_URL];
    imagePost.postDate  = [objectDict valueForKey:KEY_DATE];
    
    //TODO add pictures imagePost
    
    NSError* error;
    if (![self.managedObjectContext save:&error]) {
        LogError(@"error adding object:\n%@", [error userInfo]);
    }
    else {
        [self performSelectorOnMainThread:@selector(addNewPost:) withObject:imagePost waitUntilDone:YES];
    }
}

- (void)downloadData:(UITableView*)view {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    //--------------
    //NSDateFormatter* formatter = [[[NSDateFormatter alloc] init] autorelease];
    //[formatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate *date = [self mostRecentPostDate];
    //NSString* strDate = [formatter stringFromDate:date];
    //LogDebug(@"most recent post date: ", strDate);
    //--------------
    
    NSArray *webPosts = [self.converter convertGallery:GD_ARCHIVE_IOTD_PAGE_URL];
    NSDictionary *objectDict;
    for (objectDict in webPosts) {
        if ([self existsInDatabase:objectDict] == NO) {
            [self addToDatabase:objectDict];
        }
    }
    if (view != nil) {
        [view reloadData];
    }
    
    [pool drain];
}

- (void)refreshFromWeb:(UITableView*)view {
    [NSThread detachNewThreadSelector:@selector(downloadData:) toTarget:self withObject:view];
}

@end
