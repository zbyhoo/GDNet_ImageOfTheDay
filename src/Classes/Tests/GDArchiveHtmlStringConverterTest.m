//
//  GDArchiveHtmlStringConverterTest.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 2/16/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "../GDArchiveHtmlStringConverter.h"
#import "../Constants.h"

@interface GDArchiveHtmlStringConverterTest : GHTestCase {
}

+ (NSString*)readSampleMainPageFile;
@end

@interface GDArchiveHtmlStringConverterMock : GDArchiveHtmlStringConverter {
}
@end
@implementation GDArchiveHtmlStringConverterMock
- (NSString*)getData:(NSString*)urlString
{
    return [GDArchiveHtmlStringConverterTest readSampleMainPageFile];
}
@end

@implementation GDArchiveHtmlStringConverterTest

+ (NSString*)readSampleMainPageFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample_archive_main_page" ofType:@"html"]; 
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}


- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
    return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class 
}

- (void)tearDownClass {
    // Run at end of all tests in the class
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}  

- (void) testSplitHtmlToPosts {
    
    // give 
    GDArchiveHtmlStringConverter *converter = [[GDArchiveHtmlStringConverter alloc] init];
    NSString *htmlContent = [GDArchiveHtmlStringConverterTest readSampleMainPageFile];
    
    // when
    NSMutableArray *posts = [converter splitHtmlToPosts:htmlContent];
    
    // then
    GHAssertNotNil(posts, @"should return not empty array of not parsed posts");
    GHAssertEquals([posts count], (NSUInteger)16, @"number of posts per page");
    
    [converter release];
}

- (void) testSplitHtmlToPosts_noPosts {
    
    // give 
    GDArchiveHtmlStringConverter *converter = [[GDArchiveHtmlStringConverter alloc] init];
    NSString *htmlContent = @"nothing interesting here";
    
    // when
    NSMutableArray *posts = [converter splitHtmlToPosts:htmlContent];
    
    // then
    GHAssertNotNil(posts, @"should return array");
    GHAssertEquals([posts count], (NSUInteger)0, @"number of posts per page");
    
    [converter release];
}

- (void) testConvertGalleryWithSampleImagesPage {
    
    // given
    GDArchiveHtmlStringConverter *converter = [[GDArchiveHtmlStringConverterMock alloc] init];
    NSString *fakeUrl = @"http://zbyhoo.eu";
    
    // when
    NSArray *results = [converter convertGallery:fakeUrl];
    
    // then
    GHAssertNotNil(results, @"should return NSArray");
    GHAssertEquals([results count], (NSUInteger)16, @"number of parsed posts");
    
    [converter release];
}

- (void) testParsePost {
    // given
    GDArchiveHtmlStringConverter *converter = [[GDArchiveHtmlStringConverterMock alloc] init];
    NSString *dateString = @"1/4/2011";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [df dateFromString: dateString];
    [df release];
    NSString *user = @"MrJolly";
    NSString *url = @"topic.asp?topic_id=591877";
    NSString *title = @"Vampire Slayer Squad (Android game)";
    NSString *imgUrl = @"http://images.gamedev.net/gallery/t591877_0.jpg";
    NSString *post = [NSString stringWithFormat:@"\t\t\t\n\t\tPosted %@ By <a title=\"View this users profile\" href=\"profile.asp?id=177184\"><span class=\"regularfont\"><span class=\"smallfont\">%@</span></span></a>\n\t\t<br>\n\t\t<a href=\"%@\" title=\"%@\">\n\t\t\t<img src=\"%@\">\t\t\n\t\t<br>\t\t\t\t\t\t\n\t\t7 Comments \n\t\t</a>\n\t\t<br>\n\t\t<b>%@</b>\t\t\t\n\t\t</td>\n\t\t\t\t\n\t\t",
                      dateString, user, url, title, imgUrl, title];
    [GDArchiveHtmlStringConverter setHelperIndex:0];
    
    // when
    NSDictionary *imagePost = [converter parsePost:post];
    
    // then
    GHAssertNotNil(imagePost, @"post shouldn't be nil");
    double timestamp = [date timeIntervalSince1970];
    NSNumber *parsedTs = [imagePost valueForKey:KEY_DATE];
    GHAssertEquals([parsedTs doubleValue], timestamp, @"post date comaprison");
    GHAssertEqualObjects([imagePost valueForKey:KEY_AUTHOR], user, @"user comaprison");
    NSString *expected = [NSString stringWithFormat:@"%@%@", GD_ARCHIVE_POST_URL, url];
    GHAssertEqualObjects([imagePost valueForKey:KEY_POST_URL], expected, @"url comaprison");
    GHAssertEqualObjects([imagePost valueForKey:KEY_TITLE], title, @"title comaprison");
    GHAssertEqualObjects([imagePost valueForKey:KEY_IMAGE_URL], imgUrl, @"image url comaprison");
    
    [converter release];
}


@end
