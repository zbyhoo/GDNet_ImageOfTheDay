//
//  GameDevDataManager.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 4/26/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "GameDevArchiveDataManager.h"
#import "GDArchiveHtmlStringConverter.h"

@implementation GameDevArchiveDataManager

NSString * const GD_ARCHIVE_LASTEST_POST_DATE = @"GD_ARCHIVE_LASTEST_POST_DATE";

- (id)init 
{
    if ((self = [super init])) 
    {
        GDArchiveHtmlStringConverter *gdConverter = [[GDArchiveHtmlStringConverter alloc] init];
        self.converter = gdConverter;
        [gdConverter release];
    }
    return self;
}

- (NSPredicate*)getPredicateWithDeleted:(BOOL)deleted 
{    
    NSString *predicateString = [NSString stringWithFormat:@"(type like '%@') AND (deleted==%d) AND (favourite==0)", 
                                 NSStringFromClass([GDArchiveHtmlStringConverter class]), 
                                 deleted];
    return [NSPredicate predicateWithFormat:predicateString];
}

- (NSPredicate*)getPredicate
{
    NSString *predicateString = [NSString stringWithFormat:@"(type like '%@')", 
                                 NSStringFromClass([GDArchiveHtmlStringConverter class])];
    return [NSPredicate predicateWithFormat:predicateString];
}

- (NSString*)getLastestPostDateKey
{
    return GD_ARCHIVE_LASTEST_POST_DATE;
}

@end
