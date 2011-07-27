//
//  Posts.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 7/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "Posts.h"
#import "GDImagePost.h"
#import "ImagesCache.h"
#import "GDPicture.h"

@interface Posts (Private)
- (void) storePictureOfPost:(GDImagePost*)post;
@end

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
    _posts = [[NSMutableArray alloc] init];
    
    for (GDImagePost* post in posts)
    {
        [self addPostAtProperIndex:post];
    }
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
    [self storePictureOfPost:post];
}

- (void) addPost:(GDImagePost*)post
{
    [_posts addObject:post];
    [self storePictureOfPost:post];
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

- (void) storePictureOfPost:(GDImagePost*)post
{
    for (GDPicture* picture in post.pictures) 
    {
        if (picture.pictureDescription != nil && [picture.pictureDescription compare:MAIN_IMAGE_OBJ] == NSOrderedSame)
        {
            [[ImagesCache instance] addImageData:picture.smallPictureData forKey:picture.smallPictureUrl];
        }
    }
}

@end
