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
@private
    GDArchiveHtmlStringConverter *_converter;
}
@property (nonatomic, retain) GDArchiveHtmlStringConverter *converter;
+ (NSString*)readSampleMainPageFile;
@end

@interface GDArchiveHtmlStringConverterMock : GDArchiveHtmlStringConverter {
}
@end

@implementation GDArchiveHtmlStringConverterMock
- (NSString*)getData:(NSString*)urlString {
    return [GDArchiveHtmlStringConverterTest readSampleMainPageFile];
}
@end

@implementation GDArchiveHtmlStringConverterTest

@synthesize converter = _converter;

+ (NSString*)readSampleMainPageFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample_archive_main_page" ofType:@"html"]; 
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (void)setUpClass {
    _converter = [[GDArchiveHtmlStringConverter alloc] init];
}

- (void)tearDownClass {
    self.converter = nil;
}

- (void)testSplitHtmlToPosts {
    
    // given 
    NSString *htmlContent = [GDArchiveHtmlStringConverterTest readSampleMainPageFile];
    
    // when
    NSMutableArray *posts = [self.converter splitHtmlToPosts:htmlContent];
    
    // then
    GHAssertNotNil(posts, @"should return not empty array of not parsed posts");
    GHAssertEquals([posts count], (NSUInteger)16, @"number of posts per page");
}

- (void)testSplitHtmlToPosts_noPosts {
    
    // given
    NSString *htmlContent = @"nothing interesting here";
    
    // when
    NSMutableArray *posts = [self.converter splitHtmlToPosts:htmlContent];
    
    // then
    GHAssertNotNil(posts, @"should return array");
    GHAssertEquals([posts count], (NSUInteger)0, @"number of posts per page");
}

- (void)testSplitHtmlToPosts_halfOfPageOnly {
    
    // given
    NSString *htmlContent = [GDArchiveHtmlStringConverterTest readSampleMainPageFile];
    htmlContent = [htmlContent substringToIndex:([htmlContent length]/2)];
    
    // when
    NSMutableArray *posts = [self.converter splitHtmlToPosts:htmlContent];
    
    // then
    GHAssertNotNil(posts, @"should return array");
    GHAssertEquals([posts count], (NSUInteger)2, @"number of posts per page");
}

- (void) testConvertGalleryWithSampleImagesPage {
    
    // given
    
    // when
    NSArray *results = [self.converter convertGalleryWithDate:nil latest:YES];
    
    // then
    GHAssertNotNil(results, @"should return NSArray");
    GHAssertEquals([results count], (NSUInteger)16, @"number of parsed posts");
}

- (void) testParsePost {
    // given
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
    NSDictionary *imagePost = [self.converter parsePost:post];
    
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
}

@end
