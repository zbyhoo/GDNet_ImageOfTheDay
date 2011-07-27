//
//  Posts.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 7/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "Posts.h"
#import "GDImagePost.h"

@implementation Posts

- (id)init
{
    self = [super init];
    if (self) {
        _posts = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void) dealloc
{
    [_posts release];
    _posts = nil;
    
    [super dealloc];
}

- (void) preloadWithPosts:(NSArray*)posts
{
    [_posts release];
    _posts = [posts retain];
}

- (NSUInteger)count
{
    return _posts.count;
}

- (GDImagePost*) postAtIndex:(NSUInteger)index
{
    return [_posts objectAtIndex:index];
}

- (void) removePostAtIndex:(NSUInteger)index
{
    [_posts removeObjectAtIndex:index];
}

- (void) insertPost:(GDImagePost*)post atIndex:(NSUInteger)index
{
    [_posts insertObject:post atIndex:index];
}

- (void) addPost:(GDImagePost*)post
{
    [_posts addObject:post];
}

- (void) addPostAtProperIndex:(GDImagePost*)post
{
    NSUInteger index = 0;
    for (GDImagePost *stored in _posts) 
    {
        if ([post.postDate intValue] >= [stored.postDate intValue])
        {
            [self insertPost:post atIndex:index];
            return;
        }
        ++index;
    }
    [self addPost:post];
}

@end
