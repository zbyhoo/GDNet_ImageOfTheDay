//
//  ImagesCache.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 7/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "ImagesCache.h"

@implementation ImagesCache

static ImagesCache* sharedImagesCache = nil;

- (id)init
{
    self = [super init];
    if (self) {
        _uiImages = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) dealloc
{
    [_uiImages release];
    _uiImages = nil;
    
    [super dealloc];
}

+ (ImagesCache*) instance
{
    if (sharedImagesCache == nil)
    {
        @synchronized(self)
        {
            if (sharedImagesCache == nil)
                sharedImagesCache = [[ImagesCache alloc] init];
        }
    }
    return sharedImagesCache;
}

- (void) addImageData:(NSData*)data forKey:(NSString*)key
{
    @synchronized(self)
    {
        id image = [_uiImages objectForKey:key];
        if (image == nil)
        {
            UIImage* image = [UIImage imageWithData:data];
            [_uiImages setObject:image forKey:key];
        }
    }
}

- (UIImage*) getImageForKey:(NSString*)key
{
    @synchronized(self)
    {
        return (UIImage*)[_uiImages objectForKey:key];
    }
}

- (void) removeImageForKey:(NSString*)key
{
    @synchronized(self)
    {
        id image = [_uiImages objectForKey:key];
        if (image != nil)
            [_uiImages removeObjectForKey:key];
    }
}

- (void) removeAllImages
{
    @synchronized(self)
    {
        LogWarning(@"removing all images");
        [_uiImages removeAllObjects];
    }
}

@end
