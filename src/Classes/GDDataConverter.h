//
//  GDDataParser.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDImagePost.h"

@protocol GDDataConverter

- (NSArray*)convertGallery:(NSString*)data;
- (GDImagePost*)convertPost:(NSString*)data;

@end
