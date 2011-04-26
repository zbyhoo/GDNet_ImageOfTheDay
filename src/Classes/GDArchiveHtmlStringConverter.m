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


NSString * const GD_ARCHIVE_POST_SEPARATOR      = @"<td class=\"smallfont\" align=\"center\" valign=\"top\" width=\"25%\">";
NSString * const GD_ARCHIVE_LAST_POST_SEPARATOR = @"</tr>";

NSString * const GD_ARCHIVE_DATE_START      = @"Posted ";
NSString * const GD_ARCHIVE_DATE_END        = @" By <a";
NSString * const GD_ARCHIVE_USER_START      = @"<span class=\"smallfont\">";
NSString * const GD_ARCHIVE_USER_END        = @"</span></span>";
NSString * const GD_ARCHIVE_URL_START       = @"<a href=\"";
NSString * const GD_ARCHIVE_URL_END         = @"\" ti";
NSString * const GD_ARCHIVE_TITLE_START     = @"tle=\"";
NSString * const GD_ARCHIVE_TITLE_END       = @"\">";
NSString * const GD_ARCHIVE_IMG_URL_START   = @"img src=\"";
NSString * const GD_ARCHIVE_IMG_URL_END     = @"\">";

NSString * const GD_ARCHIVE_POST_URL        = @"http://archive.gamedev.net/community/forums/";

NSString * const GD_ARCHIVE_POST_DATE_START = @"Posted -";
NSString * const GD_ARCHIVE_POST_DATE_END   = @"</td>";
NSString * const GD_ARCHIVE_POST_IMGS_START = @"<td class=\"forumcell\"";
NSString * const GD_ARCHIVE_POST_IMGS_END   = @"<!--StartImageData-->";
NSString * const GD_ARCHIVE_POST_PRE_URL    = @"http://archive.gamedev.net/community/forums/";
NSString * const GD_ARCHIVE_POST_DESC_START = @"EndImageData-->";
NSString * const GD_ARCHIVE_POST_DESC_END   = @"<x x=\"\"></x><x x=\"\"></x></td>";


@implementation GDArchiveHtmlStringConverter

- (id)init
{
    if ((self = [super init])) 
    {
        _templateUrl = @"http://archive.gamedev.net/community/forums/gallery.asp?forum_id=62&PageSize=16&WhichPage=";
    }
    return self;
}

- (void)resetUrlCounter
{
    _currentPage = 0;
}

- (NSString*)getNextUrl
{
    _currentPage += 1;
    return [NSString stringWithFormat:@"%@%d", _templateUrl, _currentPage];
}

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
    NSRange range;
    range.location = 0;
    range.length = chunk.length - 1;
    
    NSNumber *date;
    NSString *user;
    NSString *postUrl;
    NSString *title;
    NSString *imgUrl;
    
    @try {
        NSString *dateString = [Utilities getSubstringFrom:chunk range:&range after:GD_ARCHIVE_DATE_START before:GD_ARCHIVE_DATE_END];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM/dd/yyyy"];
        double timestamp = [[df dateFromString: dateString] timeIntervalSince1970];
        
        date = [NSNumber numberWithDouble:timestamp];
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
    [dict setValue:date forKey:KEY_DATE];
    [dict setValue:user forKey:KEY_AUTHOR];
    [dict setValue:postUrl forKey:KEY_POST_URL];
    [dict setValue:title forKey:KEY_TITLE];
    [dict setValue:imgUrl forKey:KEY_IMAGE_URL];
    [dict setValue:NSStringFromClass(self.class) forKey:KEY_TYPE];
    
    return [dict autorelease];
}

- (NSString*)getLargeImageUrl:(NSString*)url {
    
    NSString *picPage = [self getData:url];
    NSRange range;
    range.location = 0;
    range.length = picPage.length - 1;
    
    @try {
        return [Utilities getSubstringFrom:picPage range:&range after:@"src=\"" before:@"\" title"];
    }
    @catch (NSException *exception) {
        LogError(@"unknown exception catched");
    }
    return nil;
}

- (NSArray*)convertImageUrls:(NSString*)chunk {
    
    NSRange range;
    range.location = 0;
    range.length = chunk.length - 1;
    
    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
    
    @try {
        NSString *mainImage = [Utilities getSubstringFrom:chunk range:&range after:@"\" src=\"" before:@"\" title"];
        [array addObject:mainImage];
    }
    @catch (NSException *exception) {
        LogError(@"unable to get url of main image");
        return nil;
    }
    
    @try {
        NSString *largeImage;
        NSString *smallImage;
        while (YES) {
            largeImage = [Utilities getSubstringFrom:chunk range:&range after:@"<a href=\"" before:@"\" target"];
            if (largeImage == nil) {
                break;
            }
            else if ([largeImage hasPrefix:@"gallery"]) {
                largeImage = [self getLargeImageUrl:[NSString stringWithFormat:@"%@%@", GD_ARCHIVE_POST_PRE_URL, largeImage]];
            }
            // TODO parse title here
            smallImage = [Utilities getSubstringFrom:chunk range:&range after:@"src=\"" before:@"\"></a>"];           
            
            [array addObject:smallImage];
            [array addObject:largeImage];
        }
    }
    @catch (NSException *exception) {
        LogError(@"unknown exception catched");
    }
    LogDebug(@"finished parsing images");
    
    LogDebug(@"%@", array);
    
    return array;
}

- (NSDictionary*)convertPost:(NSString*)data {
    NSString *page = [self getData:data];
    
    NSString *dateString;
    NSString *imagesChunk;
    NSString *description;
    
    NSRange range;
    range.location = 0;
    range.length = page.length - 1;
    
    @try {
        dateString = [Utilities getSubstringFrom:page range:&range after:GD_ARCHIVE_POST_DATE_START before:GD_ARCHIVE_POST_DATE_END];
        NSInteger i = 0;
        while ([[NSCharacterSet whitespaceCharacterSet] characterIsMember:[dateString characterAtIndex:i]]) {
            i++;
        }
        dateString = [dateString substringFromIndex:i];
        LogDebug(@"Post date: %@", dateString);
        
        imagesChunk = [Utilities getSubstringFrom:page range:&range after:GD_ARCHIVE_POST_IMGS_START before:GD_ARCHIVE_POST_IMGS_END];
        LogDebug(@"Images URLs:\n%@", imagesChunk);
        
        description = [Utilities getSubstringFrom:page range:&range after:GD_ARCHIVE_POST_DESC_START before:GD_ARCHIVE_POST_DESC_END];
        LogDebug(@"Description:\n%@", description);
    }
    @catch (NSException *exception) {
        LogError(@"error with parsing post details:\n%@", page);
        return nil;
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:description forKey:KEY_DESCRIPTION];
    
    NSLocale* usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setLocale:usLocale];
    [df setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    double timestamp = [[df dateFromString: dateString] timeIntervalSince1970];
    [df release];
    [dict setValue:[NSNumber numberWithDouble:timestamp] forKey:KEY_DATE];
    
    NSArray *imageUrls = [self convertImageUrls:imagesChunk];
    int index = 0;

    for (NSString *url in imageUrls) {
        
        NSString *properUrl = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *key = [NSString stringWithFormat:@"%@%d", KEY_IMAGE_URL, index++];
        LogDebug(@"IMG URL: %@", properUrl);
        LogDebug(@"FOR KEY: %@", key);
        [dict setValue:properUrl forKey:key];
    }
    [dict setValue:[NSNumber numberWithInt:index] forKey:KEY_IMAGES_COUNT];
    
    return [dict autorelease];
}

@end
