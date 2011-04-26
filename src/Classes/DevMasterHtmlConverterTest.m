//
//  DevMasterHtmlConverterTest.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 4/26/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//


#import "DevMasterHtmlConverter.h"

@interface DevMasterHtmlConverterMock : DevMasterHtmlConverter 
- (void)setCurrentPage:(int)value;
@end
@implementation DevMasterHtmlConverterMock
- (void)setCurrentPage:(int)value
{
    _currentPage = value;
}
@end

@interface DevMasterHtmlConverterTest : GHTestCase
@end
@implementation DevMasterHtmlConverterTest

+ (NSString*)readSampleMainPageFile 
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample_devmaster_main" ofType:@"html"]; 
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

+ (NSString*)readSamplePostFile 
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"devmaster_post" ofType:@"html"]; 
    return [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
}

- (void)test_init
{
    // given
    id converterId = [DevMasterHtmlConverter alloc];
    
    // when
    DevMasterHtmlConverter *converter = [converterId init];
    
    // then
    GHAssertEquals(converter.templateUrl, @"http://www.devmaster.net/snapshot/index.php?start=", @"");
    GHAssertEquals(converter.step, 16, @"");
    GHAssertEquals(converter.currentPage, -16, @"");
    
    [converter release];
}

- (void)test_resetUrlCounter
{
    // given
    DevMasterHtmlConverterMock *converter = [[DevMasterHtmlConverterMock alloc] init];
    [converter setCurrentPage:32];
    
    // when
    [converter resetUrlCounter];
    
    // then
    GHAssertEquals(converter.currentPage, -converter.step, @"");
    
    [converter release];
}

- (void)test_getNextUrl
{
    // given
    DevMasterHtmlConverter *converter = [[DevMasterHtmlConverter alloc] init];
    
    // when
    NSString *url = [converter getNextUrl];
    
    // then
    NSString *expected = [NSString stringWithFormat:@"%@%d", converter.templateUrl, 0];
    GHAssertEqualObjects(url, expected, @"");
    
    [converter release];
}

- (void)test_getNextUrl_twice
{
    // given
    DevMasterHtmlConverter *converter = [[DevMasterHtmlConverter alloc] init];
    
    // when
    [converter getNextUrl];
    NSString *url = [converter getNextUrl];
    
    // then
    NSString *expected = [NSString stringWithFormat:@"%@%d", converter.templateUrl, converter.step];
    GHAssertEqualObjects(url, expected, @"");
    
    [converter release];
}

- (void)test_splitHtmlToPosts
{
    // given
    DevMasterHtmlConverter *converter = [[DevMasterHtmlConverter alloc] init];
    NSString *pageContent = [DevMasterHtmlConverterTest readSampleMainPageFile];
    
    // when
    NSArray *postChunks = [converter splitHtmlToPosts:pageContent];
    
    // then
    GHAssertNotNil(postChunks, @"");
    GHAssertEquals(postChunks.count, (NSUInteger)16, @"");
    
    [converter release];
}

- (void)test_parsePost
{
    // given
    DevMasterHtmlConverter *converter = [[DevMasterHtmlConverter alloc] init];
    NSString *postContent = [DevMasterHtmlConverterTest readSamplePostFile];
    
    // when
    NSDictionary *parsedPost = [converter parsePost:postContent];
    
    // then
    GHAssertNotNil(parsedPost, @"");
    GHAssertEqualObjects([parsedPost valueForKey:KEY_TITLE], @"Dot Boxing", @"");
    GHAssertEqualObjects([parsedPost valueForKey:KEY_AUTHOR], @"Chris", @"");
    //GHAssertEqualObjects([parsedPost valueForKey:KEY_DATE], @"Dot Boxing", @"");
    GHAssertEqualObjects([parsedPost valueForKey:KEY_POST_URL], @"http://www.devmaster.net/snapshot/../forums/showthread.php?t=17215", @"");
    GHAssertEqualObjects([parsedPost valueForKey:KEY_IMAGE_URL], @"http://www.devmaster.net/snapshot/images/11-03-20.thm.jpg", @"");
    
    [converter release];
}

@end
