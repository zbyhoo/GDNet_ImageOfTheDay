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
    
    NSDate *date;
    NSString *user;
    NSString *postUrl;
    NSString *title;
    NSString *imgUrl;
    
    @try {
        NSString *dateString = [Utilities getSubstringFrom:chunk range:&range after:GD_ARCHIVE_DATE_START before:GD_ARCHIVE_DATE_END];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy"];
        date = [df dateFromString: dateString];
        [df release];
        LogDebug(@"Date: %@", date);
        
        user = [Utilities getSubstringFrom:chunk range:&range after:GD_ARCHIVE_USER_START before:GD_ARCHIVE_USER_END];
        LogDebug(@"User: %@", user);
        
        postUrl = [Utilities getSubstringFrom:chunk range:&range after:GD_ARCHIVE_URL_START before:GD_ARCHIVE_URL_END];
        postUrl = [NSString stringWithFormat:@"%@%@", GD_ARCHIVE_POST_URL, postUrl];
        LogDebug(@"Post URL: %@", postUrl);
        
        title = [Utilities getSubstringFrom:chunk range:&range after:GD_ARCHIVE_TITLE_START before:GD_ARCHIVE_TITLE_END];
        LogDebug(@"Title: %@", title);
        
        imgUrl = [Utilities getSubstringFrom:chunk range:&range after:GD_ARCHIVE_IMG_URL_START before:GD_ARCHIVE_IMG_URL_END];
        LogDebug(@"Image Url: %@", imgUrl);
    }
    @catch (NSException * e) {
        LogError(@"error with parsing post:\n%@", chunk);
        return nil;
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:date forKey:@"postDate"];
    [dict setValue:user forKey:@"author"];
    [dict setValue:postUrl forKey:@"url"];
    [dict setValue:title forKey:@"title"];
    [dict setValue:imgUrl forKey:@"imageUrl"];
    
    return [dict autorelease];
}

@end
