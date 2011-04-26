//
//  GDHtmlStringConverterTest.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 2/8/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "../GDHtmlStringConverter.h"


@interface GDHtmlStringConverterTest : GHTestCase {
    GDHtmlStringConverter *_converter;
}
@end


@implementation GDHtmlStringConverterTest

- (BOOL)shouldRunOnMainThread {
    // By default NO, but if you have a UI test or test dependent on running on the main thread return YES
    return NO;
}

- (void)setUpClass {
    // Run at start of all tests in the class
    _converter = [[GDHtmlStringConverter alloc] init];
}

- (void)tearDownClass {
    // Run at end of all tests in the class
    [_converter release];
}

- (void)setUp {
    // Run before each test method
}

- (void)tearDown {
    // Run after each test method
}  

- (void) testConvertGalleryWithNullStringPassed {
    
    // given
    
    // when
    NSArray *results = [_converter convertGalleryWithDate:nil latest:YES];
    
    // then
    GHAssertNotNil(results, @"Should always return NSArray");
    GHAssertTrue([results count] == 0, @"Number of converted posts should be %d", 0);
}

- (void) testConvertGalleryWithSample {
    
    // given
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"sample_archive_1" ofType:@"html"];  
    //NSString *fileText = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    // when
    //NSArray *results = [_converter convertGallery:fileText];
    
    // then
    //GHAssertNotNil(results, @"Should always return NSArray");
    //GHAssertEquals([results count], 9, @"Number of parsed posts"); 
    //GHAssertNotNil(nil, @"not implemented - waiting for gamedev.net");
}

- (void) testConvertPostWithNullStringPassed {
    
    // given
    NSString *data = nil;
    
    // when
    NSDictionary *convertedPost = [_converter convertPost:data];
    
    // then
    GHAssertNil(convertedPost, @"Should return nil if wron parameter passed");
}



@end
