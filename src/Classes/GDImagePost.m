//
//  GDImagePost.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/17/11.
//  Copyright (c) 2011 zbyhoo. All rights reserved.
//

#import "GDImagePost.h"
#import "GDPicture.h"


@implementation GDImagePost
@dynamic author;
@dynamic deleted;
@dynamic title;
@dynamic postDescription;
@dynamic postDate;
@dynamic favourite;
@dynamic url;
@dynamic type;
@dynamic pictures;

- (void)addPicturesObject:(GDPicture *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"pictures" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"pictures"] addObject:value];
    [self didChangeValueForKey:@"pictures" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePicturesObject:(GDPicture *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"pictures" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"pictures"] removeObject:value];
    [self didChangeValueForKey:@"pictures" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPictures:(NSSet *)value {    
    [self willChangeValueForKey:@"pictures" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"pictures"] unionSet:value];
    [self didChangeValueForKey:@"pictures" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePictures:(NSSet *)value {
    [self willChangeValueForKey:@"pictures" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"pictures"] minusSet:value];
    [self didChangeValueForKey:@"pictures" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
