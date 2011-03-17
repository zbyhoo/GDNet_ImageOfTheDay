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

@synthesize mainUrl = _mainUrl;

- (id)init {
    if ((self = [super init])) {
        self.mainUrl = GD_ARCHIVE_IOTD_PAGE_URL;
    }
    return self;
}

- (void)dealloc {
    self.mainUrl = nil;
    [super dealloc];
}

- (int)converterId {
    return CONVERTER_GD;
}

- (NSArray*)convertGalleryWithDate:(NSNull*)timestamp latest:(BOOL)latest {
    
    NSString *pageContent = [self getData:self.mainUrl];
    NSMutableArray *chunks = [self splitHtmlToPosts:pageContent];
    LogInfo(@"%@", chunks);
    
    NSMutableArray *posts = [[NSMutableArray alloc] init];
    NSString *chunk;
    for (chunk in chunks) {
        NSDictionary *newPost = [self parsePost:chunk];
        if (newPost != nil) {
            [posts addObject:newPost];
        }
    }
    
    return [posts autorelease];
}

- (NSDictionary*)parsePost:(NSString*)chunk {
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

- (NSDictionary*)convertPost:(NSString*)data {
    LogError(@"method not implemented");
    return nil;
}

@end
