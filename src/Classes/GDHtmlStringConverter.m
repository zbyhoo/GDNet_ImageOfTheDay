//
//  GDStringParser.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "GDHtmlStringConverter.h"
#import "Constants.h"

@implementation GDHtmlStringConverter

- (NSArray*)convertGallery:(NSString*)data {
    
    if (data == nil) {
        LogWarning(@"nil data argument passed");
        return nil;
    }
    
    NSString *pageContent = [self getData:data];
    NSMutableArray *chunks = [self splitHtmlToPosts:pageContent];

    //TODO futher parsing
    
    //TODO remove log or only in debug
    LogInfo(@"%@", chunks);
    
    
    //return [[[NSArray alloc] init] autorelease];
    return nil;
}

- (NSString*)getData:(NSString*)urlString {
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:urlString];
    return [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
}

- (NSMutableArray*)splitHtmlToPosts:(NSString*)htmlPage {
    NSMutableArray *chunks = [NSMutableArray arrayWithArray:[htmlPage componentsSeparatedByString:GD_POST_SEPARATOR]];
    
    if ([chunks count] <= 1) {
        LogWarning(@"no post sections found");
    }
    else {
        [chunks removeObjectAtIndex:0];    
    }
    
    return chunks;
}

- (NSPredicate*)isPostLikePredicate {
    return nil;
}

- (GDImagePost*)convertPost:(NSString*)data {
    LogError(@"method not implemented");
    return nil;
}

@end
