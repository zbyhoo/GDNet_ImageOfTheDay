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
    
    NSError *error = nil;
    NSURL *url = [NSURL URLWithString:data];
    NSString *pageContent = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    //TODO error checking
    

    NSMutableArray *chunks = [NSMutableArray arrayWithArray:[pageContent componentsSeparatedByString:GD_POST_SEPARATOR]];
    [chunks removeObjectAtIndex:0];
    //TODO futher parsing
    
    //TODO remove log or only in debug
    NSLog(@"%@", chunks);
    
    
    //return [[[NSArray alloc] init] autorelease];
    return nil;
}

- (GDImagePost*)convertPost:(NSString*)data {
    return nil;
}

@end
