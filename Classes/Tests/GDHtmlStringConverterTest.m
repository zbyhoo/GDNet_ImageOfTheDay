//
//  GDHtmlStringConverterTest.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 2/8/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h> 
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
    NSString *data = nil;
    
    // when
    NSArray *results = [_converter convertGallery:data];
    
    // then
    GHAssertNotNil(results, @"Should always return NSArray");
    GHAssertTrue([results count] == 0, @"Number of converted posts should be %d", 0);
}

- (void) testConvertPostWithNullStringPassed {
    
    // given
    NSString *data = nil;
    
    // when
    GDImagePost *convertedPost = [_converter convertPost:data];
    
    // then
    GHAssertNil(convertedPost, @"Should return nil if wron parameter passed");
}



@end
