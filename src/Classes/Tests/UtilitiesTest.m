//
//  UtilitiesTest.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/2/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "../Utilities.h"
#import "../Constants.h"

@interface UtilitiesTest : GHTestCase {
}
@end

@implementation UtilitiesTest

- (void) testSubstring_properData {
    
    // given
    NSString *string    = @"after_text_before";
    NSString *after     = @"after";
    NSString *before    = @"before";
    NSRange range;
    range.location  = 0;
    range.length    = string.length - 1;
    
    // when
    NSString *substring = [Utilities getSubstringFrom:string range:&range after:after before:before];
    
    // then
    GHAssertNotNil(substring, @"shouldn't be nil");
    GHAssertTrue([substring compare:@"_text_"] == NSOrderedSame, @"something is wrong");
    NSUInteger expected = 17;
    GHAssertEquals(range.location, expected , @"range after computation");
}

- (void) testSubstring_realLifeData {
    
    // given
    NSString *string    = @"\n\t\tPosted 1/4/2011 By <a title=\"View this";
    NSRange range;
    range.location  = 0;
    range.length    = string.length - 1;
    
    // when
    NSString *substring = [Utilities getSubstringFrom:string range:&range after:GD_ARCHIVE_DATE_START before:GD_ARCHIVE_DATE_END];
    
    // then
    GHAssertNotNil(substring, @"shouldn't be nil");
    GHAssertTrue([substring compare:@"1/4/2011"] == NSOrderedSame, @"something is wrong");
    NSUInteger expected = 24;
    GHAssertEquals(range.location, expected , @"range after computation");
}

- (void) testSubstring_missingAfter {
    // given
    NSString *string    = @"after_text_before";
    NSString *after     = @"missing";
    NSString *before    = @"before";
    NSRange range;
    range.location  = 0;
    range.length    = string.length - 1;
    
    // when
    NSString *substring = [Utilities getSubstringFrom:string range:&range after:after before:before];
    
    // then
    GHAssertNil(substring, @"should be nil");
}

- (void) testSubstring_missingBefore {
    // given
    NSString *string    = @"after_text_before";
    NSString *after     = @"after";
    NSString *before    = @"missing";
    NSRange range;
    range.location  = 0;
    range.length    = string.length - 1;
    
    // when
    NSString *substring = [Utilities getSubstringFrom:string range:&range after:after before:before];
    
    // then
    GHAssertNil(substring, @"should be nil");
}

- (void) testSubstring_wrongRangeLength {
    // given
    NSString *string    = @"after_text_before";
    NSString *after     = @"after";
    NSString *before    = @"missing";
    NSRange range;
    range.location  = 0;
    range.length    = string.length;
    
    // when
    NSString *substring = [Utilities getSubstringFrom:string range:&range after:after before:before];
    
    // then
    GHAssertNil(substring, @"should be nil");
}

@end
