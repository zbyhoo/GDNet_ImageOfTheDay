//
//  GDStringParser.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "GDDataConverter.h"

@interface GDHtmlStringConverter : NSObject <GDDataConverter> {
@private
    NSString *_mainUrl;
}

@property (nonatomic, retain) NSString *mainUrl;

- (NSString*)getData:(NSString*)urlString;
- (NSPredicate*)isPostLikePredicate;
- (NSMutableArray*)splitHtmlToPosts:(NSString*)htmlPage;
- (NSDictionary*)parsePost:(NSString*)chunk;

@end
