//
//  ConvertersManager.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 4/3/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "GDDataConverter.h"

@interface ConvertersManager : NSObject {
@private
    NSMutableArray *_converters;
}

@property (nonatomic, readonly) NSMutableArray *converters;

- (void)initializeConvertersArray;
- (BOOL)isProperClassType:(Class)aClass;
- (void)addConverter:(Class)aClass;
- (void)createConverters;
- (BOOL)isConvertersArrayInitilized;
- (NSArray*)getConverters;
- (NSObject<GDDataConverter>*)getConverterType:(NSString*)type;
- (BOOL)isTheSameConverter:(NSObject<GDDataConverter>*)converter type:(NSString*)type;

@end
