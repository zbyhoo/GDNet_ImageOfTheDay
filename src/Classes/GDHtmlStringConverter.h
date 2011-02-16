//
//  GDStringParser.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDDataConverter.h"


@interface GDHtmlStringConverter : NSObject <GDDataConverter> {

}

- (NSString*)getData:(NSString*)urlString;
- (NSPredicate*)isPostLikePredicate;
- (NSMutableArray*)splitHtmlToPosts:(NSString*)htmlPage;

@end
