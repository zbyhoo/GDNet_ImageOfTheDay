//
//  GDStringParser.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "GDHtmlStringConverter.h"
#import "Constants.h"

NSString * const GD_POST_SEPARATOR  = @"<div class='gallery_album";

@implementation GDHtmlStringConverter

- (void)dealloc {
    [super dealloc];
}

- (NSArray*)convertGalleryWithDate:(NSNumber*)timestamp latest:(BOOL)latest 
{    
    if (latest)
        return [self getNewPostsStartingFrom:timestamp];
    else
        return [self getOldPostsStartingFrom:timestamp];
}

- (NSDictionary*)parsePost:(NSString*)chunk {
    return nil;
}

- (NSString*)getData:(NSString*)urlString {
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    LogDebug(@"getting data from: %@", url);
    NSString *pageContent = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:&error];
    return pageContent;
}

- (NSMutableArray*)splitHtmlToPosts:(NSString*)htmlPage {
    NSMutableArray *chunks = [NSMutableArray arrayWithArray:[htmlPage componentsSeparatedByString:GD_POST_SEPARATOR]];
    
    if ([chunks count] <= 1) {
        LogWarning(@"no post sections found");
    }
    else {
        [chunks removeObjectAtIndex:0];    
    }
    
    return chunks;
}

- (NSPredicate*)isPostLikePredicate {
    return nil;
}

- (NSDictionary*)convertPost:(NSString*)data {
    LogError(@"method not implemented");
    return nil;
}

- (void)resetUrlCounter
{
}

- (void)resetOldUrlCounter
{
}

- (void)setOldUrlCounter
{
}

- (NSString*)getNextUrl
{
    return nil;
}

- (NSArray*)getPosts
{
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    
    NSString *pageContent = [self getData:[self getNextUrl]];
    NSMutableArray *chunks = [self splitHtmlToPosts:pageContent];
    
    for (NSString *chunk in chunks) 
    {
        NSDictionary *newPost = [self parsePost:chunk];
        if (newPost != nil) 
        {
            [posts addObject:newPost];
        }
    }
    
    return [posts autorelease];
}

- (NSArray*)getNewPostsStartingFrom:(NSNumber*)timestamp
{
    [self resetUrlCounter];
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    BOOL morePosts = YES;
    
    while (morePosts)
    {
        [posts addObjectsFromArray:[self getPosts]];
        if (timestamp && [timestamp intValue] > 0)
        {
            NSUInteger counter =  posts.count;
            [posts filterUsingPredicate:[self getNewerPostsPredicate:timestamp]];
            if (counter > posts.count)
                morePosts = NO;
        }
        else
        {
            return [posts autorelease];
        }
    }
    
    return [posts autorelease];
}

- (NSArray*)getOldPostsStartingFrom:(NSNumber*)timestamp
{
    [self resetOldUrlCounter];
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    
    while (posts.count < (NSUInteger)10)
    {
        [posts addObjectsFromArray:[self getPosts]];
        [posts filterUsingPredicate:[self getOlderPostsPredicate:timestamp]];
    }
    
    [self setOldUrlCounter];
    
    return [posts autorelease];
}

- (NSPredicate*)getNewerPostsPredicate:(NSNumber*)timestamp
{
    NSString *predicateString = [NSString stringWithFormat:@"(%@ >= %d)", KEY_DATE, [timestamp intValue]];
    return [NSPredicate predicateWithFormat:predicateString];
}

- (NSPredicate*)getOlderPostsPredicate:(NSNumber*)timestamp
{
    NSString *predicateString = [NSString stringWithFormat:@"(%@ < %d)", KEY_DATE, [timestamp intValue]];
    return [NSPredicate predicateWithFormat:predicateString];
}

@end
