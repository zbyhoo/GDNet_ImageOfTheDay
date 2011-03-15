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
#import "TableViewCell.h"
#import "GDPicture.h"
#import "DBHelper.h"
#import "ImageDetailViewController.h"

@implementation DataManager

#pragma mark -
#pragma mark Instance stuff

@synthesize posts = _posts;
@synthesize dbHelper = _dbHelper;
@synthesize converter = _converter;

- (id)initWithDataType:(int)type 
              dbHelper:(DBHelper*)dbHelper 
             converter:(NSObject<GDDataConverter>*)converter {
    if ((self = [super init])) {
        _dataType = type;
        self.dbHelper = dbHelper;
        self.converter = converter;
    }
    return self;
}

- (id)initWithDbHelper:(DBHelper *)dbHelper 
             converter:(NSObject<GDDataConverter> *)converter {
    if ((self = [super init])) {
        _dataType = -1;
        self.dbHelper = dbHelper;
        self.converter = converter;
    }
    return self;
}

- (void)dealloc {
    self.posts = nil;
    self.dbHelper = nil;
    self.converter = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Business stuff

- (void)preloadData:(UITableView*)view {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"postDate" ascending:NO];
    
    NSString *predicateString = [NSString stringWithFormat:@"(deleted==%d) AND (favourite==%d)", NO, (_dataType == POST_FAVOURITE)];
    LogDebug(@"preload predicate (data type %d): %@", _dataType, predicateString);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    
    self.posts = [self.dbHelper fetchObjects:@"GDImagePost" predicate:predicate sorting:sortDescriptor];
    [sortDescriptor release];
    
    if (self.posts.count == 0 && _dataType != POST_FAVOURITE) {
        [NSThread detachNewThreadSelector:@selector(downloadData:) toTarget:self withObject:view];
    }
    
    [self.dbHelper markUpdated];
}

- (void)refresh:(UITableView*)view {
    if ([self.dbHelper isModified]) {
        [self preloadData:view];
        [view reloadData];
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
    
    GDPicture *picture = [[post.pictures allObjects] objectAtIndex:0];
    UIImage *image = [UIImage imageWithData:picture.smallPictureData];
    cell.postImageView.image = image;
    //cell.titleLabel.text = [NSString stringWithFormat:@"%d", post.postDate];
}

- (void)addToFavourites:(NSIndexPath*)position view:(UITableView*)view {
    GDImagePost* post = [self.posts objectAtIndex:position.row];
    post.favourite = [NSNumber numberWithBool:YES];
    
    if ([self.dbHelper saveContext]) {
        [self.posts removeObjectAtIndex:position.row];
        [self.dbHelper markModified];
    }
}

- (void)deletePost:(NSIndexPath*)position permanent:(BOOL)permanent {
    // TODO check in the future relationships
    if (permanent == YES) {
        if ([self.dbHelper deleteObject:[self.posts objectAtIndex:position.row]] == NO) {
            LogError(@"unable to delete post");
            return;
        }
    }
    else {
        GDImagePost* post = [self.posts objectAtIndex:position.row];
        post.deleted = [NSNumber numberWithBool:YES];
    }
    
    [self.posts removeObjectAtIndex:position.row];
}

- (NSNumber*)mostRecentPostDate {
    
    NSSortDescriptor *sorting = [[NSSortDescriptor alloc] initWithKey:@"postDate" ascending:YES];
    NSArray* objects = [self.dbHelper fetchObjects:@"GDImagePost" predicate:nil sorting:sorting];
    [sorting release];
    
    if (objects != nil && [objects count] > 0) {
        GDImagePost* post = (GDImagePost*)[objects objectAtIndex:0];
        return post.postDate;
    }
    return nil;
}

- (BOOL)existsInDatabase:(NSDictionary*)objectDict {
    NSPredicate *requestPredicate = [NSPredicate 
                                     predicateWithFormat:[NSString stringWithFormat:@"(url like '%@')", [objectDict valueForKey:KEY_POST_URL]]];    
    LogDebug(@"searching core data for: %@", [objectDict valueForKey:KEY_POST_URL]);

    NSArray *array = [self.dbHelper fetchObjects:@"GDImagePost" predicate:requestPredicate sorting:nil];
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

- (void)downloadImages:(GDImagePost*)post {
    GDPicture *picture;
    for (picture in post.pictures) {
        NSURL *imgUrl   = [NSURL URLWithString:picture.smallPictureUrl];
        picture.smallPictureData = [NSData dataWithContentsOfURL:imgUrl];
    }
}

- (void)addToDatabase:(NSDictionary*)objectDict {
    GDImagePost* imagePost = (GDImagePost*)[self.dbHelper createNew:@"GDImagePost"];
    imagePost.author    = [objectDict valueForKey:KEY_AUTHOR];
    imagePost.title     = [objectDict valueForKey:KEY_TITLE];
    imagePost.url       = [objectDict valueForKey:KEY_POST_URL];
    imagePost.postDate  = [objectDict valueForKey:KEY_DATE];
    
    GDPicture *picture      = (GDPicture*)[self.dbHelper createNew:@"GDPicture"];
    picture.imagePost       = imagePost;
    picture.smallPictureUrl = [objectDict valueForKey:KEY_IMAGE_URL];
    
    imagePost.pictures  = [NSSet setWithObject:picture]; 
    
    [self downloadImages:imagePost];
    
    if([self.dbHelper saveContext]) {
        [self performSelectorOnMainThread:@selector(addNewPost:) withObject:imagePost waitUntilDone:YES];
    }
}

- (void)downloadData:(UITableView*)view {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSNumber *timestamp = [self mostRecentPostDate];
    LogDebug(@"most recent post date: %d", [timestamp intValue]);
    
    // TODO download until timestamp met
    NSArray *webPosts = [self.converter convertGallery:GD_ARCHIVE_IOTD_PAGE_URL];
    NSDictionary *objectDict;
    for (objectDict in webPosts) {
        if ([self existsInDatabase:objectDict] == NO) {
            NSNumber *postDate = [objectDict valueForKey:KEY_DATE];
            if ([postDate intValue] >= [timestamp intValue]) {
                [self addToDatabase:objectDict];
                if (view != nil) {
                    [view reloadData];
                }
            }
        }
    }
    
    [pool drain];
}

- (void)refreshFromWeb:(UITableView*)view {
    [NSThread detachNewThreadSelector:@selector(downloadData:) toTarget:self withObject:view];
}

- (void)downloadPostInfoWithView:(ImageDetailViewController*)view {
    NSString *predicateString = [NSString stringWithFormat:@"(url LIKE \"%@\")", view.postId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSMutableArray *array = [self.dbHelper fetchObjects:@"GDImagePost" predicate:predicate sorting:nil];
    if (array.count != 1) {
        LogError(@"wrong number of returned elements: expected %d, current %d", 1, array.count);
        return;
    }
    
    NSDictionary *postDict = [self.converter convertPost:view.postId];
    if (postDict == nil) {
        return;
    }
    
    GDImagePost *post = [array objectAtIndex:0];
    post.postDescription = [postDict objectForKey:KEY_DESCRIPTION];
    
    [self.dbHelper saveContext];
    
    if([self.dbHelper saveContext]) {
        [view performSelectorOnMainThread:@selector(updateView:) withObject:post waitUntilDone:NO];
    }
}

- (void)getPostInfoWithView:(ImageDetailViewController*)view {
    [NSThread detachNewThreadSelector:@selector(downloadPostInfoWithView:) toTarget:self withObject:view];
}

- (NSString*)getTitleOfPostAtIndex:(NSIndexPath*)indexPath {
    GDImagePost *post = [self.posts objectAtIndex:indexPath.row];
    return post.title;
}

- (NSString*)getPostIdAtIndex:(NSIndexPath*)indexPath {
    GDImagePost *post = [self.posts objectAtIndex:indexPath.row];
    return post.url;
}

@end
