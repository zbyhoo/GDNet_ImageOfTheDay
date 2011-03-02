//
//  GDArchiveHtmlStringConverter.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 2/16/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "GDArchiveHtmlStringConverter.h"
#import "Constants.h"
#import "Utilities.h"
#import "GDImagePost.h"

@implementation GDArchiveHtmlStringConverter

- (NSMutableArray*)splitHtmlToPosts:(NSString*)htmlPage {
    NSMutableArray *chunks = [NSMutableArray arrayWithArray:[htmlPage componentsSeparatedByString:GD_ARCHIVE_POST_SEPARATOR]];
    
    if ([chunks count] <= 1) {
        LogWarning(@"no post sections found");
    }
    else {
        [chunks removeObjectAtIndex:0];  
        NSString* last = [chunks lastObject];
        last = [[last componentsSeparatedByString:GD_ARCHIVE_LAST_POST_SEPARATOR] objectAtIndex:0];
        [chunks replaceObjectAtIndex:([chunks count] - 1) withObject:last];
    }
    
    LogDebug(@"before filtering:\n%@", chunks);
    [chunks filterUsingPredicate:[self isPostLikePredicate]];
    LogDebug(@"after filtering:\n%@", chunks);
    
    return chunks;
}

- (NSPredicate*)isPostLikePredicate {
    return [NSPredicate predicateWithFormat:@"SELF MATCHES '.*Posted.*By.*(a title).*Comment(s)*.*'"];
}                                            

- (NSDictionary*)parsePost:(NSString*)chunk {
    LogDebug(@"%@", chunk);
    
    NSRange range;
    range.location = 0;
    range.length = chunk.length - 1;
    
    NSString *date = [Utilities getSubstringFrom:chunk range:&range after:GD_ARCHIVE_DATE_START before:GD_ARCHIVE_DATE_END];
    LogDebug(@"Date: %@", date);
    NSString *user = [Utilities getSubstringFrom:chunk range:&range after:GD_ARCHIVE_USER_START before:GD_ARCHIVE_USER_END];
    LogDebug(@"User: %@", user);
    NSString *title = [Utilities getSubstringFrom:chunk range:&range after:GD_ARCHIVE_TITLE_START before:GD_ARCHIVE_TITLE_END];
    LogDebug(@"Title: %@", title);
    NSString *imgUrl = [Utilities getSubstringFrom:chunk range:&range after:GD_ARCHIVE_IMG_URL_START before:GD_ARCHIVE_IMG_URL_END];
    LogDebug(@"Image Url: %@", imgUrl);
    
    // TODO parse and add the rest data
    
    return nil;
}

@end
