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
#import "ImagesListViewController.h"

@interface DataManager (Private)
- (BOOL)saveModifiedContext;
@end

@implementation DataManager

@synthesize posts       = _posts;
@synthesize dbHelper    = _dbHelper;
@synthesize converter   = _converter;

- (id)initWithDbHelper:(DBHelper*)dbHelper 
{
    if ((self = [super init])) 
    {
        self.dbHelper = dbHelper;
        _downloadingDataCounter = 0;
    }
    return self;
}

- (id)init 
{
    if ((self = [super init])) 
    {
        _dbHelper = [[DBHelper alloc]init];
        _downloadingDataCounter = 0;
    }
    return self;
}

- (void)dealloc 
{
    self.posts = nil;
    self.dbHelper = nil;
    self.converter = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Business stuff

- (NSSortDescriptor*)getDateSortDescriptor 
{    
    return [[[NSSortDescriptor alloc] initWithKey:@"postDate" ascending:NO] autorelease];
}

- (NSPredicate*)getPredicateWithDeleted:(BOOL)deleted 
{    
    NSString *predicateString = [NSString stringWithFormat:@"(deleted==%d) AND (favourite==0)", deleted];
    return [NSPredicate predicateWithFormat:predicateString];
}

- (BOOL)shouldDownloadData 
{    
    return (self.posts.count == 0);
}

- (void)preloadData:(ImagesListViewController*)view 
{    
    self.posts = [self.dbHelper 
                  fetchObjects:@"GDImagePost" 
                  predicate:[self getPredicateWithDeleted:NO] 
                  sorting:[self getDateSortDescriptor]];
    
    if ([self shouldDownloadData])
    {
        [NSThread detachNewThreadSelector:@selector(downloadNewData:) toTarget:self withObject:view];
    }
    
    [self.dbHelper markUpdated];
}

- (void)refresh:(ImagesListViewController*)view
{
    [self preloadData:view];
    [view reloadViewData];
}

- (NSUInteger)postsCount
{ 
    return self.posts.count; 
}

- (BOOL)saveModifiedContext
{
    if ([self.dbHelper saveContext]) 
    {
        [self.dbHelper markModified];
        return YES;
    }
    return NO;
}

- (BOOL)addPostToFavourites:(GDImagePost*)post
{    
    post.favourite = [NSNumber numberWithBool:YES];
    return [self saveModifiedContext];
}

- (BOOL)removePostFromFavorites:(GDImagePost*)post
{    
    post.favourite = [NSNumber numberWithBool:NO];
    return [self saveModifiedContext];
}

- (void)addToFavourites:(NSIndexPath*)position 
{    
    GDImagePost* post = [self.posts objectAtIndex:position.row];
    if ([self addPostToFavourites:post])
    {
        [self.posts removeObjectAtIndex:position.row];
    }
}

- (void)removeFromFavorites:(NSIndexPath *)position
{    
    GDImagePost* post = [self.posts objectAtIndex:position.row];
    if ([self removePostFromFavorites:post])
    {
        [self.posts removeObjectAtIndex:position.row];
    }
}

- (void)removeDataFromPost:(GDImagePost*)post
{
    NSMutableSet *pictureSet = [NSMutableSet setWithSet:post.pictures];
    for (GDPicture *picture in pictureSet)
        if ([self.dbHelper deleteObject:picture] == NO)
            LogError(@"unable to delete picture");
    post.pictures = nil;
}

- (void)markDeleted:(NSIndexPath*)position
{    
    GDImagePost* post = [self.posts objectAtIndex:position.row];
    [self removeDataFromPost:post];
    post.deleted = [NSNumber numberWithBool:YES];
    [self saveModifiedContext];
    [self.posts removeObjectAtIndex:position.row];
}

- (void)permanentlyDeletePost:(NSIndexPath*)position
{
    if ([self.dbHelper deleteObject:[self.posts objectAtIndex:position.row]] == NO)
    {
        LogError(@"unable to delete post");
        return;
    }
    [self.posts removeObjectAtIndex:position.row];
}

- (NSPredicate*)getPredicate
{
    return nil;
}

- (NSNumber*)mostRecentPostDate
{    
    NSArray* objects = [self.dbHelper fetchObjects:@"GDImagePost" predicate:[self getPredicate] sorting:[self getDateSortDescriptor]];
    
    if ([objects count] > 0) 
    {
        return ((GDImagePost*)[objects objectAtIndex:0]).postDate;
    }
    return nil;
}

- (NSNumber*)oldestPostDate
{    
    NSArray* objects = [self.dbHelper fetchObjects:@"GDImagePost" predicate:nil sorting:[self getDateSortDescriptor]];
    
    if ([objects count] > 0) 
    {
        return ((GDImagePost*)[objects lastObject]).postDate;
    }
    return nil;
}

- (NSPredicate*)getPredicateWithUrlFromDict:(NSDictionary*)dict 
{
    return [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(url like '%@')", [dict valueForKey:KEY_POST_URL]]];    
}

- (BOOL)existsInDatabase:(NSDictionary*)objectDict 
{
    NSArray *array = [self.dbHelper fetchObjects:@"GDImagePost" predicate:[self getPredicateWithUrlFromDict:objectDict] sorting:nil];
    if (array == nil || array.count <= (NSUInteger)0) 
    {
        return NO;
    }
    
    return YES;
}

- (void)addNewPost:(GDImagePost*)post 
{
    NSUInteger index = 0;
    for (GDImagePost *stored in self.posts) 
    {
        if ([post.postDate intValue] >= [stored.postDate intValue])
        {
            [self.posts insertObject:post atIndex:index];
            return;
        }
        ++index;
    }
    [self.posts addObject:post];
}

- (NSData*)downloadImageFromUrl:(NSString*)url
{
    [self dataDownloadStarted];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    [self dataDownloadEnded];
    
    return imageData;
}

- (BOOL)downloadLargeImage:(GDPicture*)picture
{
    if (picture.largePictureData)
    {
        return YES;
    }
    
    picture.largePictureData = [self downloadImageFromUrl:picture.largePictureUrl];
    BOOL success = (picture.largePictureData != nil);
    success |= [self saveModifiedContext];
    return success;
}

- (void)downloadImages:(GDImagePost*)post withLarge:(BOOL)largeAlso
{
    for (GDPicture *picture in post.pictures) 
    {
        picture.smallPictureData = [self downloadImageFromUrl:picture.smallPictureUrl];
        
        if (largeAlso && picture.largePictureUrl) 
        {
            picture.largePictureData = [self downloadImageFromUrl:picture.largePictureUrl];
        }
    }
}

- (void)downloadImages:(GDImagePost*)post
{    
    [self downloadImages:post withLarge:NO];
}

- (void)addToDatabase:(NSDictionary*)objectDict 
{    
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
    
    if([self.dbHelper saveContext])
    {
        [self performSelectorOnMainThread:@selector(addNewPost:) withObject:imagePost waitUntilDone:YES];
    }
}

- (void)updateTableView:(ImagesListViewController*)view
{
    [view performSelectorOnMainThread:NSSelectorFromString(@"reloadViewData") withObject:nil waitUntilDone:YES];
}

- (BOOL)shouldAddNewPost:(NSDictionary*)dict timestamp:(int)timestamp
{
    return ([self existsInDatabase:dict] == NO);
}

- (void)getPostsFromConverter:(NSObject<GDDataConverter>*)converter timestamp:(int)timestamp view:(ImagesListViewController*)view latest:(BOOL)latest
{
    NSArray *webPosts = [converter convertGalleryWithDate:[NSNumber numberWithInt:timestamp] latest:latest];
    
    for (NSDictionary *objectDict in webPosts)
    {
        if ([self shouldAddNewPost:objectDict timestamp:timestamp])
        {
            [self addToDatabase:objectDict];
            [self updateTableView:view];
        }
    }
}

- (void)downloadData:(ImagesListViewController*)view new:(BOOL)newData timestamp:(NSNumber*)timestamp
{    
    @synchronized(view.tableView)
    {        
        [self dataDownloadStarted];
        [self getPostsFromConverter:self.converter timestamp:[timestamp intValue] view:view latest:newData];
        [self dataDownloadEnded];
    }
    
    [view performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:NO];
}

- (void)downloadNewData:(ImagesListViewController*)view 
{    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSNumber *timestamp = [self mostRecentPostDate];
    LogDebug(@"most recent post date timestamp: %d", [timestamp intValue]);
    
    [self downloadData:view new:YES timestamp:timestamp];
    
    [pool drain];
}

- (void)downloadOldData:(ImagesListViewController*)view 
{   
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    NSNumber *timestamp = [self oldestPostDate];
    LogDebug(@"oldest post date timestamp: %d", [timestamp intValue]);
    [self downloadData:view new:NO timestamp:timestamp];
    
    [pool drain];
}

- (void)refreshFromWeb:(ImagesListViewController*)view 
{    
    [NSThread detachNewThreadSelector:@selector(downloadNewData:) toTarget:self withObject:view];
}

- (void)getOlderFromWeb:(ImagesListViewController *)view
{
    [NSThread detachNewThreadSelector:@selector(downloadOldData:) toTarget:self withObject:view];
}

- (NSPredicate*)getPostPredicateWithId:(NSString*)postId
{
    return [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(url LIKE \"%@\")", postId]];
}

- (void)updatePost:(GDImagePost*)post withData:(NSDictionary*)postDict
{
    post.postDescription = [postDict objectForKey:KEY_DESCRIPTION];
    post.postDate = [postDict objectForKey:KEY_DATE];
    
    NSMutableSet *picturesSet = [NSMutableSet setWithSet:post.pictures];
    
    int index = 0;
    for (GDPicture* mainPicture in picturesSet) 
    {
        mainPicture.largePictureUrl = [postDict objectForKey:[NSString stringWithFormat:@"%@%d", KEY_IMAGE_URL, index++]];
        LogDebug(@"%@", mainPicture.largePictureUrl);
    }
    
    NSNumber *count = [postDict objectForKey:KEY_IMAGES_COUNT];
    while (index < [count intValue]) 
    {
        GDPicture *picture = (GDPicture*)[self.dbHelper createNew:@"GDPicture"];
        picture.imagePost = post;
        picture.smallPictureUrl = [postDict objectForKey:[NSString stringWithFormat:@"%@%d", KEY_IMAGE_URL, index++]];
        picture.largePictureUrl = [postDict objectForKey:[NSString stringWithFormat:@"%@%d", KEY_IMAGE_URL, index++]];
        [picturesSet addObject: picture];
    }
    [self downloadImages:post withLarge:NO];
    post.pictures = [NSSet setWithArray:[picturesSet allObjects]];
}

- (GDImagePost*)downloadPostWithId:(NSString*)postId
{
    NSMutableArray *array = [self.dbHelper 
                             fetchObjects:@"GDImagePost" 
                             predicate:[self getPostPredicateWithId:postId] 
                             sorting:nil];
    
    if (!array || array.count != 1) 
    {
        LogError(@"wrong number of returned elements: expected %d, current %d", 1, array.count);
        return nil;
    }
    
    GDImagePost *post = [array objectAtIndex:0];
    
    [self dataDownloadStarted];
    NSDictionary *postDict = [self.converter convertPost:postId];
    
    if (!postDict) 
    {
        [self dataDownloadEnded];
        return nil;
    }
    [self updatePost:post withData:postDict];
    
    [self dataDownloadEnded];
    
    return post;
}

- (void)downloadPostInfoWithView:(PostDetailsController*)view 
{    
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    GDImagePost *post = [self downloadPostWithId:view.postId];
    if (post && [self.dbHelper saveContext])
    {
        [view performSelectorOnMainThread:@selector(updateView:) withObject:post waitUntilDone:NO];
    }
    
    [pool drain];
}

- (GDImagePost*)getPostWithId:(NSString*)postId 
{    
    NSMutableArray *array = [self.dbHelper 
                             fetchObjects:@"GDImagePost" 
                             predicate:[self getPostPredicateWithId:postId] 
                             sorting:nil];
    if (array.count != 1) 
    {
        LogError(@"wrong number of returned elements: expected %d, current %d", 1, array.count);
        return nil;
    }
   return [array objectAtIndex:0];
}

- (void)getPostInfoWithView:(PostDetailsController*)view 
{    
    GDImagePost *post = [self getPostWithId:view.postId];
    
    if ([post.postDescription length] > 0) 
    {
        for (GDPicture *picture in post.pictures) 
        {
            LogDebug(@"small url: %@", picture.smallPictureUrl);
            LogDebug(@"large url: %@", picture.largePictureUrl);  
            LogDebug(@"small data: %d", picture.smallPictureData);
            LogDebug(@"large data: %d", picture.largePictureData);  
        }
        
        [view updateView:post];
    }
    else 
    {
        [NSThread detachNewThreadSelector:@selector(downloadPostInfoWithView:) toTarget:self withObject:view];
    }
}

- (NSString*)getTitleOfPostAtIndex:(NSIndexPath*)indexPath 
{
    GDImagePost *post = [self.posts objectAtIndex:indexPath.row];
    return post.title;
}

- (NSString*)getPostIdAtIndex:(NSIndexPath*)indexPath 
{
    GDImagePost *post = [self.posts objectAtIndex:indexPath.row];
    return post.url;
}

- (GDImagePost*)getPostAtIndex:(NSIndexPath*)indexPath 
{
    GDImagePost *post = [self.posts objectAtIndex:indexPath.row];
    return post;
}



- (void)dataDownloadStarted_mainThread
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    @synchronized(self)
    {
        NSLog(@"start DD -- : %d", _downloadingDataCounter);
        if (_downloadingDataCounter == 0)
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
        ++_downloadingDataCounter;
    }
    
    [pool drain];
}

- (void)dataDownloadStarted
{
    [self performSelectorOnMainThread:@selector(dataDownloadStarted_mainThread) withObject:nil waitUntilDone:YES];
}

- (void)dataDownloadEnded_mainThread
{
    @synchronized(self)
    {
        NSLog(@"end DD -- : %d", _downloadingDataCounter);
        --_downloadingDataCounter;
        if (_downloadingDataCounter == 0)
        {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }
}

- (void)dataDownloadEnded
{
    [self performSelectorOnMainThread:@selector(dataDownloadEnded_mainThread) withObject:nil waitUntilDone:YES];
}

@end
