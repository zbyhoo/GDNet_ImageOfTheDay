//
//  GDArchiveHtmlStringConverterTest.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 2/16/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "../GDArchiveHtmlStringConverter.h"

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
    NSUInteger expectedPostsCount = 16;
    
    // when
    NSMutableArray *posts = [converter splitHtmlToPosts:htmlContent];
    
    // then
    GHAssertNotNil(posts, @"should return not empty array of not parsed posts");
    GHAssertEquals([posts count], expectedPostsCount, @"number of posts per page");
    
    [converter release];
}

- (void) testSplitHtmlToPosts_noPosts {
    
    // give 
    GDArchiveHtmlStringConverter *converter = [[GDArchiveHtmlStringConverter alloc] init];
    NSString *htmlContent = @"nothing interesting here";
    NSUInteger expectedPostsCount = 0;
    
    // when
    NSMutableArray *posts = [converter splitHtmlToPosts:htmlContent];
    
    // then
    GHAssertNotNil(posts, @"should return array");
    GHAssertEquals([posts count], expectedPostsCount, @"number of posts per page");
    
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
    GHAssertEquals([results count], 9, @"number of parsed posts");
    
    [converter release];
}


@end
