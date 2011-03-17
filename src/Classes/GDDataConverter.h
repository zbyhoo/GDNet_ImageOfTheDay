//
//  GDDataParser.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GDDataConverter

- (NSArray*)convertGalleryWithDate:(NSNull*)timestamp latest:(BOOL)latest;
- (NSDictionary*)convertPost:(NSString*)data;
- (int)converterId;

@end
