//
//  DevMasterHtmlConverter.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 4/26/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "DevMasterHtmlConverter.h"
#import "Utilities.h"

NSString * const DM_POST_SEPARATOR      = @"<table width=\"100%\" class=\"smallfont\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">";
NSString * const DM_LAST_POST_SEPARATOR = @"</table>";

NSString * const DM_TITLE_START         = @"<td><b>";
NSString * const DM_TITLE_END           = @"</b></td>";
NSString * const DM_USER_START          = @"<i>";
NSString * const DM_USER_END            = @"</i><br";
NSString * const DM_DATE_START          = @", ";
NSString * const DM_DATE_END            = @"<br />";
NSString * const DM_URL_START           = @"<a href=\"";
NSString * const DM_URL_END             = @"\"><img";
NSString * const DM_POST_URL            = @"http://www.devmaster.net/snapshot/";
NSString * const DM_IMG_URL_START       = @"src=\"";
NSString * const DM_IMG_URL_END         = @"\"></a>";
NSString * const DM_POST_DATE_START     = @"alt=\"Old\" border=\"0\" /></a>";
NSString * const DM_POST_DATE_END       = @"<!-- / status icon and date -->";
NSString * const DM_POST_PRE_IMGS_START = @"<!-- message -->";
NSString * const DM_POST_PRE_IMGS_END   = @"id=\"post_message";
NSString * const DM_POST_IMGS_START     = @"<div align=\"center\"><img src=\"";
NSString * const DM_POST_IMGS_END       = @"\" border";
NSString * const DM_POST_DESC_START     = @"Description</font></b><br />";
NSString * const DM_POST_DESC_END       = @"</div>";


@implementation DevMasterHtmlConverter

@synthesize templateUrl = _templateUrl;
@synthesize step = _step;
@synthesize currentPage = _currentPage;

- (id)init
{
    if ((self = [super init])) 
    {
        _templateUrl = @"http://www.devmaster.net/snapshot/index.php?start=";
        _step = 16;
        _currentPage = -_step;
    }
    return self;
}

- (void)resetUrlCounter
{
    _currentPage = -_step;
}

- (NSString*)getNextUrl
{
    _currentPage += _step;
    return [NSString stringWithFormat:@"%@%d", _templateUrl, _currentPage];
}

- (NSMutableArray*)splitHtmlToPosts:(NSString*)htmlPage 
{
    NSMutableArray *chunks = [NSMutableArray arrayWithArray:[htmlPage componentsSeparatedByString:DM_POST_SEPARATOR]];
    
    if ([chunks count] <= 1) 
    {
        LogWarning(@"no post sections found");
    }
    else 
    {
        [chunks removeObjectAtIndex:0];  
        NSString* last = [chunks lastObject];
        last = [[last componentsSeparatedByString:DM_LAST_POST_SEPARATOR] objectAtIndex:0];
        [chunks replaceObjectAtIndex:([chunks count] - 1) withObject:last];
    }
    
    return chunks;
}                                        

- (NSNumber*)stringToTimestamp:(NSString*)dateString
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSLocale* usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    [df setLocale:usLocale];
    [usLocale release];
    [df setDateFormat:@"dd MMMMM yyyy"];
    double timestamp = [[df dateFromString: dateString] timeIntervalSince1970];
    NSNumber *date = [NSNumber numberWithDouble:timestamp];
    [df release];
    return date;
}

- (NSDictionary*)parsePost:(NSString*)chunk 
{    
    NSRange range;
    range.location = 0;
    range.length = chunk.length - 1;
    
    NSNumber *date;
    NSString *user;
    NSString *postUrl;
    NSString *title;
    NSString *imgUrl;
    
    @try {
        title = [Utilities getSubstringFrom:chunk range:&range after:DM_TITLE_START before:DM_TITLE_END];
        LogDebug(@"Title: %@", title);
        
        user = [Utilities getSubstringFrom:chunk range:&range after:DM_USER_START before:DM_USER_END];
        LogDebug(@"User: %@", user);
        
        NSString *dateString = [Utilities getSubstringFrom:chunk range:&range after:DM_DATE_START before:DM_DATE_END];
        date = [self stringToTimestamp:dateString];
        LogDebug(@"Date: %@", date);
                
        postUrl = [Utilities getSubstringFrom:chunk range:&range after:DM_URL_START before:DM_URL_END];
        postUrl = [NSString stringWithFormat:@"%@%@", DM_POST_URL, postUrl];
        LogDebug(@"Post URL: %@", postUrl);
        
        imgUrl = [Utilities getSubstringFrom:chunk range:&range after:DM_IMG_URL_START before:DM_IMG_URL_END];
        imgUrl = [NSString stringWithFormat:@"%@%@", DM_POST_URL, imgUrl];
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

- (NSNumber*)convertPostExactDate:(NSString*)dateString
{
    NSString *trimmedString = [dateString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSLocale* usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    [df setLocale:usLocale];
    [df setDateFormat:@"MM-dd-yyyy, HH:mm a"];
    double timestamp = [[df dateFromString: trimmedString] timeIntervalSince1970];
    
    [df release];
    
    return [NSNumber numberWithDouble:timestamp];
}

- (NSDictionary*)convertPost:(NSString*)data 
{
    NSString *page = [self getData:data];
    
    NSString *dateString;
    NSString *imageUrl;
    NSString *description;
    
    NSRange range;
    range.location = 0;
    range.length = page.length - 1;
    
    NSLog(@"%@", page);
    
    @try {
        dateString = [Utilities getSubstringFrom:page range:&range after:DM_POST_DATE_START before:DM_POST_DATE_END];
        LogDebug(@"Post date: %@", dateString);
        
        [Utilities getSubstringFrom:page range:&range after:DM_POST_PRE_IMGS_START before:DM_POST_PRE_IMGS_END];
        
        imageUrl = [Utilities getSubstringFrom:page range:&range after:DM_POST_IMGS_START before:DM_POST_IMGS_END];
        LogDebug(@"Images URLs:\n%@", imageUrl);
        
        description = [Utilities getSubstringFrom:page range:&range after:DM_POST_DESC_START before:DM_POST_DESC_END];
        LogDebug(@"Description:\n%@", description);
    }
    @catch (NSException *exception) {
        LogError(@"error with parsing post details:\n%@", page);
        return nil;
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:description forKey:KEY_DESCRIPTION];
    [dict setValue:[self convertPostExactDate:dateString] forKey:KEY_DATE];
    NSString *key = [NSString stringWithFormat:@"%@%d", KEY_IMAGE_URL, 0];
    [dict setValue:imageUrl forKey:key];
    [dict setValue:[NSNumber numberWithInt:1] forKey:KEY_IMAGES_COUNT];
    
    return [dict autorelease];
}


@end
