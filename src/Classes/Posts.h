//
//  Posts.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 7/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GDImagePost;

@interface Posts : NSObject
{
@private
    NSMutableArray* _posts;
}

@property (nonatomic, readonly) NSUInteger count;

- (void) preloadWithPosts:(NSArray*)posts;
- (GDImagePost*) postAtIndex:(NSUInteger)index;
- (void) removePostAtIndex:(NSUInteger)index;
- (void) insertPost:(GDImagePost*)post atIndex:(NSUInteger)index;
- (void) addPost:(GDImagePost*)post;
- (void) addPostAtProperIndex:(GDImagePost*)post;

@end
