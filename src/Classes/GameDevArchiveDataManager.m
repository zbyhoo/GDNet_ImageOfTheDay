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

- (NSPredicate*)getPredicateWithDeleted:(BOOL)deleted 
{    
    NSString *predicateString = [NSString stringWithFormat:@"(type like '%@') AND (deleted==%d) AND (favourite==0)", 
                                 NSStringFromClass([GDArchiveHtmlStringConverter class]), 
                                 deleted];
    return [NSPredicate predicateWithFormat:predicateString];
}

@end