//
//  ConvertersManager.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 4/3/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "ConvertersManager.h"
#import "GDArchiveHtmlStringConverter.h"

@implementation ConvertersManager

@synthesize converters = _converters;

- (void)addConverter:(Class)aClass {
    
    if ([self isProperClassType:aClass]) {
    
        id converter = [[aClass alloc] init];
        [_converters addObject:converter];
        [converter release];
    }
}

- (BOOL)isProperClassType:(Class)aClass {
    
    return [aClass conformsToProtocol:@protocol(GDDataConverter)];
}

- (void)initializeConvertersArray {
    
    if (!_converters) {
        
        _converters = [[NSMutableArray alloc] init];
    }
}

- (void)createConverters {
    
    [self initializeConvertersArray];
    [self addConverter:GDArchiveHtmlStringConverter.class];
}

- (BOOL)isConvertersArrayInitilized {
    
    return _converters != nil;
}

- (NSArray*)getConverters {
    
    if (![self isConvertersArrayInitilized]) {
        
        [self createConverters];
    }
    return _converters;
}

- (NSObject<GDDataConverter>*)getConverterType:(NSString*)type {

    for (NSObject<GDDataConverter> *converter in [self getConverters]) {
        
        if ([self isTheSameConverter:converter type:type]) {
            
            return converter;
        }
    }
    LogError(@"unknown converter type: %d", type);
    return nil;
}

- (BOOL)isTheSameConverter:(NSObject<GDDataConverter>*)converter type:(NSString*)type {
    return ([NSStringFromClass(converter.class) compare:type] == NSOrderedSame);
}

@end
