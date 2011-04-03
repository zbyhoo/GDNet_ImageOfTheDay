//
//  ConvertersManagerTest.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 4/3/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "ConvertersManager.h"

#import "GDArchiveHtmlStringConverter.h"

@interface ConvertersManagerTest : GHTestCase {
@private
    ConvertersManager *_convertersManager;  
}
@end

@implementation ConvertersManagerTest

- (void)setUp {
    
    _convertersManager = [[ConvertersManager alloc] init];
}

- (void)tearDown {
    
    [_convertersManager release];
}

- (void)test_initializeConvertersArray {
    
    // given
    GHAssertNil(_convertersManager.converters, @"initially converts are nil");
    
    // when
    [_convertersManager initializeConvertersArray];
    
    // then
    GHAssertNotNil(_convertersManager.converters, @"converters array initialized");
    GHAssertEquals(_convertersManager.converters.count, (NSUInteger)0, @"converters array has no objects");
}

- (void)test_isProperClassType_properClassType {
    
    // given
    
    // when
    BOOL isProper = [_convertersManager isProperClassType:[GDArchiveHtmlStringConverter class]];
    
    // then
    GHAssertTrue(isProper, @"proper class type");
}

- (void)test_isProperClassType_wrongClassType {
    
    // given
    
    // when
    BOOL isProper = [_convertersManager isProperClassType:[NSObject class]];
    
    // then
    GHAssertFalse(isProper, @"wrong class type");
}

- (void)test_addConverter_singleGHArchiveHtmlStringConverter {
    
    // given
    [_convertersManager initializeConvertersArray];
    
    // when
    [_convertersManager addConverter:[GDArchiveHtmlStringConverter class]];
    
    // then
    GHAssertEquals(_convertersManager.converters.count, (NSUInteger)1, @"one converter added");
    GHAssertEquals([[_convertersManager.converters objectAtIndex:0] class], [GDArchiveHtmlStringConverter class],
                   @"proper class type added");
}

- (void)test_addConverter_wrongClassType {
    
    // given
    [_convertersManager initializeConvertersArray];

    // when
    [_convertersManager addConverter:[NSObject class]];
    
    // then
    GHAssertEquals(_convertersManager.converters.count, (NSUInteger)0, @"no converter added");
}

- (void)test_createConverters {
    
    // given
    ConvertersManager *manager = [[ConvertersManager alloc] init];
    
    // when
    [manager createConverters];
    
    // then
    GHAssertEquals(manager.converters.count, (NSUInteger)1, @"one converter added");
    GHAssertNotNil(manager.converters, @"converters array initialized");
    GHAssertEquals([[manager.converters objectAtIndex:0] class], [GDArchiveHtmlStringConverter class],
                   @"proper class type added");
}

- (void)test_isConvertersArrayInitialized_notInitialized {
    
    // given
    ConvertersManager *manager = [[ConvertersManager alloc] init];
    
    // when
    BOOL isInitialized = [manager isConvertersArrayInitilized];
    
    // then
    GHAssertFalse(isInitialized, @"converters array not initialized");
}

- (void)test_isConvertersArrayInitialized_initialized {
    
    // given
    ConvertersManager *manager = [[ConvertersManager alloc] init];
    [manager initializeConvertersArray];
    
    // when
    BOOL isInitialized = [manager isConvertersArrayInitilized];
    
    // then
    GHAssertTrue(isInitialized, @"converters array initialized");
}

- (void)test_getConverters {
    
    // given
    
    // when
    NSArray *converters = [_convertersManager getConverters];
    
    // then
    GHAssertEquals(converters.count, (NSUInteger)1, @"zero size of converters array");
}

- (void)test_getConverterType_existingConverterType {
    
    // given
    NSString *classString = NSStringFromClass([GDArchiveHtmlStringConverter class]);
    
    // when
    NSObject<GDDataConverter> *converter = [_convertersManager getConverterType:classString];
    
    // then
    GHAssertEquals(converter.class, [GDArchiveHtmlStringConverter class], @"proper class type returned");
}

- (void)test_getConverterType_notExistingConverterType {
    
    // given
    NSString *classString = @"someNotExistingClassNameString";
    
    // when
    NSObject<GDDataConverter> *converter = [_convertersManager getConverterType:classString];
    
    // then
    GHAssertNil(converter, @"no converter returned");
}

@end
