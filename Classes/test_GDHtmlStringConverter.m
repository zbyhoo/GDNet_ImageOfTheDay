//
//  test_GDHtmlStringConverter.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 2/2/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "test_GDHtmlStringConverter.h"


@implementation test_GDHtmlStringConverter

- (void) setUp {
    gdConverter = [[GDHtmlStringConverter alloc] init];
}

- (void) tearDown {
    [gdConverter release];
}

- (void) test_convertGallery_nullStringPassed {
    
    // given
    NSString *data = nil;
    
    // when
    NSArray *results = [gdConverter convertGallery:data];
    
    // then
    STAssertNotNil(results, @"Should always return NSArray");
    STAssertTrue([results count] == 0, @"Number of converted posts should be %d", 0);
}

- (void) test_convertPost_nullStringPassed {
    
    // given
    NSString *data = nil;
    
    // when
    GDImagePost *convertedPost = [gdConverter convertPost:data];
    
    // then
    STAssertNil(convertedPost, @"Should return nil if wron parameter passed");
}

@end
