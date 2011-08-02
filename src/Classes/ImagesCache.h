//
//  ImagesCache.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 7/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagesCache : NSObject
{
@private
    NSMutableDictionary* _uiImages;
}

+ (ImagesCache*) instance;

- (void) addImageData:(NSData*)data forKey:(NSString*)key;
- (UIImage*) getImageForKey:(NSString*)key;
- (void) removeImageForKey:(NSString*)key;
- (void) removeAllImages;

@end
