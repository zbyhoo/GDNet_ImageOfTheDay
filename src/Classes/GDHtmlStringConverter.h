//
//  GDStringParser.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "GDDataConverter.h"

@interface GDHtmlStringConverter : NSObject <GDDataConverter> 
{
}

- (NSString*)getData:(NSString*)urlString;
- (NSPredicate*)isPostLikePredicate;
- (NSMutableArray*)splitHtmlToPosts:(NSString*)htmlPage;
- (NSDictionary*)parsePost:(NSString*)chunk;

- (void)resetUrlCounter;
- (NSString*)getNextUrl;

- (NSArray*)getNewPostsStartingFrom:(NSNumber*)timestamp;
- (NSArray*)getOldPostsStartingFrom:(NSNumber*)timestamp;

- (NSPredicate*)getNewerPostsPredicate:(NSNumber*)timestamp;
- (NSPredicate*)getOlderPostsPredicate:(NSNumber*)timestamp;

- (NSArray*)getPosts;

@end
