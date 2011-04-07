//
//  FavoritesDataManager.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 4/7/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "FavoritesDataManager.h"


@implementation FavoritesDataManager

- (NSPredicate*)getPredicateWithDeleted:(BOOL)deleted 
{    
    NSString *predicateString = [NSString stringWithFormat:@"(deleted==%d) AND (favourite==1)", deleted];
    return [NSPredicate predicateWithFormat:predicateString];
}

- (BOOL)shouldDownloadData 
{    
    return NO;
}

@end
