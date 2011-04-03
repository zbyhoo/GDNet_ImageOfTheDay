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
#import "PostDetailsController.h"

#import "ConvertersManager.h"

@implementation DataManager

static ConvertersManager *convertersManager = nil;

+ (ConvertersManager*)getConvertersManager {
    if (!convertersManager) {
        convertersManager = [[ConvertersManager alloc] init];
    }
    return convertersManager;
}

@synthesize posts = _posts;
@synthesize dbHelper = _dbHelper;

- (id)initWithDataType:(int)type 
              dbHelper:(DBHelper*)dbHelper {
    if ((self = [super init])) {
        _dataType = type;
        self.dbHelper = dbHelper;
    }
    return self;
}

- (id)initWithDataType:(int)type {
    if ((self = [super init])) {
        _dataType = type;
        _dbHelper = [[DBHelper alloc]init];
    }
    return self;
}

- (id)init {
    if ((self = [super init])) {
        _dataType = -1;
        _dbHelper = [[DBHelper alloc]init];
    }
    return self;
}

- (void)dealloc {
    self.posts = nil;
    self.dbHelper = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Business stuff

- (NSSortDescriptor*)getDateSortDescriptor {
    
    return [[[NSSortDescriptor alloc] initWithKey:@"postDate" ascending:NO] autorelease];
}

- (NSPredicate*)getPredicateWithDeleted:(BOOL)deleted {

    BOOL typeFavorite = (_dataType == POST_FAVOURITE);
    
    NSString *predicateString = [NSString stringWithFormat:@"(deleted==%d) AND (favourite==%d)", deleted, typeFavorite];
    return [NSPredicate predicateWithFormat:predicateString];
}

- (BOOL)shouldDownloadData {
    
    return (self.posts.count == 0 && _dataType != POST_FAVOURITE);
}

- (void)preloadData:(UITableView*)view {
    
    self.posts = [self.dbHelper 
                  fetchObjects:@"GDImagePost" 
                  predicate:[self getPredicateWithDeleted:NO] 
                  sorting:[self getDateSortDescriptor]];
    
    if ([self shouldDownloadData]) {
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

- (void)addToFavourites:(NSIndexPath*)position {
    
    GDImagePost* post = [self.posts objectAtIndex:position.row];
    post.favourite = [NSNumber numberWithBool:YES];
    
    if ([self.dbHelper saveContext]) {
        [self.posts removeObjectAtIndex:position.row];
        [self.dbHelper markModified];
    }
}

- (void)markDeleted:(NSIndexPath*)position {
    
    GDImagePost* post = [self.posts objectAtIndex:position.row];
    post.deleted = [NSNumber numberWithBool:YES];
    [self.posts removeObjectAtIndex:position.row];
}

- (void)permanentlyDeletePost:(NSIndexPath*)position {

    if ([self.dbHelper deleteObject:[self.posts objectAtIndex:position.row]] == NO) {
     
        LogError(@"unable to delete post");
        return;
    }
    [self.posts removeObjectAtIndex:position.row];
}

- (NSNumber*)mostRecentPostDate {
    
    NSArray* objects = [self.dbHelper fetchObjects:@"GDImagePost" predicate:nil sorting:[self getDateSortDescriptor]];
    
    if ([objects count] > 0) {
        return ((GDImagePost*)[objects objectAtIndex:0]).postDate;
    }
    return nil;
}

- (NSPredicate*)getPredicateWithUrlFromDict:(NSDictionary*)dict {
    return [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(url like '%@')", [dict valueForKey:KEY_POST_URL]]];    
}

- (BOOL)existsInDatabase:(NSDictionary*)objectDict {

    NSArray *array = [self.dbHelper fetchObjects:@"GDImagePost" predicate:[self getPredicateWithUrlFromDict:objectDict] sorting:nil];
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
        
        if (picture.largePictureUrl) {
            imgUrl = [NSURL URLWithString:picture.largePictureUrl];
            picture.largePictureData = [NSData dataWithContentsOfURL:imgUrl];
        }
    }
}

- (void)addToDatabase:(NSDictionary*)objectDict {
    
    GDImagePost* imagePost = (GDImagePost*)[self.dbHelper createNew:@"GDImagePost"];
    imagePost.author    = [objectDict valueForKey:KEY_AUTHOR];
    imagePost.title     = [objectDict valueForKey:KEY_TITLE];
    imagePost.url       = [objectDict valueForKey:KEY_POST_URL];
    imagePost.postDate  = [objectDict valueForKey:KEY_DATE];
    imagePost.type      = [objectDict valueForKey:KEY_TYPE];
    
    GDPicture *picture      = (GDPicture*)[self.dbHelper createNew:@"GDPicture"];
    picture.imagePost       = imagePost;
    picture.pictureDescription = MAIN_IMAGE_OBJ;
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
    for (NSObject<GDDataConverter> *converter in [[DataManager getConvertersManager] getConverters])
    {
        NSArray *webPosts = [converter convertGalleryWithDate:nil latest:YES];
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
    }
    
    [pool drain];
}

- (void)refreshFromWeb:(UITableView*)view {
    
    [NSThread detachNewThreadSelector:@selector(downloadData:) toTarget:self withObject:view];
}

- (void)downloadPostInfoWithView:(PostDetailsController*)view {
    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSString *predicateString = [NSString stringWithFormat:@"(url LIKE \"%@\")", view.postId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    LogDebug(@"Post ID predicate: %@", predicateString);
    
    NSMutableArray *array = [self.dbHelper fetchObjects:@"GDImagePost" predicate:predicate sorting:nil];
    if (array.count != 1) {
        LogError(@"wrong number of returned elements: expected %d, current %d", 1, array.count);
        [pool drain];
        return;
    }
    
    GDImagePost *post = [array objectAtIndex:0];
    
    NSDictionary *postDict = [[[DataManager getConvertersManager] getConverterType:post.type] convertPost:view.postId];
    if (postDict == nil) {
        [pool drain];
        return;
    }
    
    post.postDescription = [postDict objectForKey:KEY_DESCRIPTION];
    LogDebug(@"--> TS : %d", [post.postDate intValue]);
    post.postDate = [postDict objectForKey:KEY_DATE];
    LogDebug(@"--> TS : %d", [post.postDate intValue]);
    
    NSMutableSet *picturesSet = [NSMutableSet setWithSet:post.pictures];
    
    int index = 0;
    for (GDPicture* mainPicture in picturesSet) {
        mainPicture.largePictureUrl = [postDict objectForKey:[NSString stringWithFormat:@"%@%d", KEY_IMAGE_URL, index++]];
        LogDebug(@"%@", mainPicture.largePictureUrl);
    }
    
    NSNumber *count = [postDict objectForKey:KEY_IMAGES_COUNT];
    while (index < [count intValue]) {
        GDPicture *picture = (GDPicture*)[self.dbHelper createNew:@"GDPicture"];
        picture.imagePost = post;
        picture.smallPictureUrl = [postDict objectForKey:[NSString stringWithFormat:@"%@%d", KEY_IMAGE_URL, index++]];
        picture.largePictureUrl = [postDict objectForKey:[NSString stringWithFormat:@"%@%d", KEY_IMAGE_URL, index++]];
        [picturesSet addObject: picture];
    }
    [self downloadImages:post];
    post.pictures = [NSSet setWithArray:[picturesSet allObjects]];
    
    if([self.dbHelper saveContext]) {
        [view performSelectorOnMainThread:@selector(updateView:) withObject:post waitUntilDone:NO];
    }
    
    [pool drain];
}

- (void)getPostInfoWithView:(PostDetailsController*)view {
    
    NSString *predicateString = [NSString stringWithFormat:@"(url LIKE \"%@\")", view.postId];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    NSMutableArray *array = [self.dbHelper fetchObjects:@"GDImagePost" predicate:predicate sorting:nil];
    if (array.count != 1) {
        LogError(@"wrong number of returned elements: expected %d, current %d", 1, array.count);
        return;
    }
    GDImagePost *post = [array objectAtIndex:0];
    if ([post.postDescription length] > 0) {
        
        for (GDPicture *picture in post.pictures) {
            LogDebug(@"small url: %@", picture.smallPictureUrl);
            LogDebug(@"large url: %@", picture.largePictureUrl);  
            LogDebug(@"small data: %d", picture.smallPictureData);
            LogDebug(@"large data: %d", picture.largePictureData);  
        }
        
        [view updateView:post];
    }
    else {
        [NSThread detachNewThreadSelector:@selector(downloadPostInfoWithView:) toTarget:self withObject:view];
    }
}

- (NSString*)getTitleOfPostAtIndex:(NSIndexPath*)indexPath {
    GDImagePost *post = [self.posts objectAtIndex:indexPath.row];
    return post.title;
}

- (NSString*)getPostIdAtIndex:(NSIndexPath*)indexPath {
    GDImagePost *post = [self.posts objectAtIndex:indexPath.row];
    return post.url;
}

- (GDImagePost*)getPostAtIndex:(NSIndexPath*)indexPath {
    GDImagePost *post = [self.posts objectAtIndex:indexPath.row];
    return post;
}

@end
