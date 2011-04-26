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
    [df setDateFormat:@"MM/dd/yyyy"];
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

- (NSString*)getLargeImageUrl:(NSString*)url 
{    
//    NSString *picPage = [self getData:url];
//    NSRange range;
//    range.location = 0;
//    range.length = picPage.length - 1;
//    
//    @try {
//        return [Utilities getSubstringFrom:picPage range:&range after:@"src=\"" before:@"\" title"];
//    }
//    @catch (NSException *exception) {
//        LogError(@"unknown exception catched");
//    }
    return nil;
}

- (NSArray*)convertImageUrls:(NSString*)chunk 
{    
//    NSRange range;
//    range.location = 0;
//    range.length = chunk.length - 1;
//    
//    NSMutableArray *array = [[[NSMutableArray alloc] initWithCapacity:0] autorelease];
//    
//    @try 
//    {
//        NSString *mainImage = [Utilities getSubstringFrom:chunk range:&range after:@"\" src=\"" before:@"\" title"];
//        [array addObject:mainImage];
//    }
//    @catch (NSException *exception) 
//    {
//        LogError(@"unable to get url of main image");
//        return nil;
//    }
//    
//    @try 
//    {
//        NSString *largeImage;
//        NSString *smallImage;
//        while (YES) 
//        {
//            largeImage = [Utilities getSubstringFrom:chunk range:&range after:@"<a href=\"" before:@"\" target"];
//            if (largeImage == nil) 
//            {
//                break;
//            }
//            else if ([largeImage hasPrefix:@"gallery"]) 
//            {
//                largeImage = [self getLargeImageUrl:[NSString stringWithFormat:@"%@%@", GD_ARCHIVE_POST_PRE_URL, largeImage]];
//            }
//            // TODO parse title here
//            smallImage = [Utilities getSubstringFrom:chunk range:&range after:@"src=\"" before:@"\"></a>"];           
//            
//            [array addObject:smallImage];
//            [array addObject:largeImage];
//        }
//    }
//    @catch (NSException *exception) 
//    {
//        LogError(@"unknown exception catched");
//    }
//    LogDebug(@"finished parsing images");
//    
//    LogDebug(@"%@", array);
//    
//    return array;
    return nil;
}

- (NSDictionary*)convertPost:(NSString*)data 
{
//    NSString *page = [self getData:data];
//    
//    NSString *dateString;
//    NSString *imagesChunk;
//    NSString *description;
//    
//    NSRange range;
//    range.location = 0;
//    range.length = page.length - 1;
//    
//    @try {
//        dateString = [Utilities getSubstringFrom:page range:&range after:GD_ARCHIVE_POST_DATE_START before:GD_ARCHIVE_POST_DATE_END];
//        NSInteger i = 0;
//        while ([[NSCharacterSet whitespaceCharacterSet] characterIsMember:[dateString characterAtIndex:i]]) {
//            i++;
//        }
//        dateString = [dateString substringFromIndex:i];
//        LogDebug(@"Post date: %@", dateString);
//        
//        imagesChunk = [Utilities getSubstringFrom:page range:&range after:GD_ARCHIVE_POST_IMGS_START before:GD_ARCHIVE_POST_IMGS_END];
//        LogDebug(@"Images URLs:\n%@", imagesChunk);
//        
//        description = [Utilities getSubstringFrom:page range:&range after:GD_ARCHIVE_POST_DESC_START before:GD_ARCHIVE_POST_DESC_END];
//        LogDebug(@"Description:\n%@", description);
//    }
//    @catch (NSException *exception) {
//        LogError(@"error with parsing post details:\n%@", page);
//        return nil;
//    }
//    
//    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//    [dict setValue:description forKey:KEY_DESCRIPTION];
//    
//    NSLocale* usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    [df setLocale:usLocale];
//    [df setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
//    double timestamp = [[df dateFromString: dateString] timeIntervalSince1970];
//    [df release];
//    [dict setValue:[NSNumber numberWithDouble:timestamp] forKey:KEY_DATE];
//    
//    NSArray *imageUrls = [self convertImageUrls:imagesChunk];
//    int index = 0;
//    
//    for (NSString *url in imageUrls) {
//        
//        NSString *properUrl = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//        
//        NSString *key = [NSString stringWithFormat:@"%@%d", KEY_IMAGE_URL, index++];
//        LogDebug(@"IMG URL: %@", properUrl);
//        LogDebug(@"FOR KEY: %@", key);
//        [dict setValue:properUrl forKey:key];
//    }
//    [dict setValue:[NSNumber numberWithInt:index] forKey:KEY_IMAGES_COUNT];
//    
//    return [dict autorelease];
    return nil;
}


@end
