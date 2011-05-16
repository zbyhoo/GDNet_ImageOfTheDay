//
//  DevMasterDataManager.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 5/3/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "DevMasterDataManager.h"
#import "DevMasterHtmlConverter.h"

@implementation DevMasterDataManager

NSString * const DM_LASTEST_POST_DATE = @"DM_LASTEST_POST_DATE";

- (id)init 
{
    if ((self = [super init])) 
    {
        DevMasterHtmlConverter *gdConverter = [[DevMasterHtmlConverter alloc] init];
        self.converter = gdConverter;
        [gdConverter release];
    }
    return self;
}

- (NSPredicate*)getPredicateWithDeleted:(BOOL)deleted 
{    
    NSString *predicateString = [NSString stringWithFormat:@"(type like '%@') AND (deleted==%d) AND (favourite==0)", 
                                 NSStringFromClass([DevMasterHtmlConverter class]), 
                                 deleted];
    return [NSPredicate predicateWithFormat:predicateString];
}

- (NSPredicate*)getPredicate
{
    NSString *predicateString = [NSString stringWithFormat:@"(type like '%@')", 
                                 NSStringFromClass([DevMasterHtmlConverter class])];
    return [NSPredicate predicateWithFormat:predicateString];
}

- (NSString*)getLastestPostDateKey
{
    return DM_LASTEST_POST_DATE;
}

@end
