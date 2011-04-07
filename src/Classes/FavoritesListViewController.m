//
//  FavoritesListViewController.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 4/7/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "FavoritesListViewController.h"
#import "DataManager.h"

@implementation FavoritesListViewController

- (void)setupDataManager
{
    DataManager *manager = [[DataManager alloc] initWithDataType:POST_FAVOURITE];
    self.dataManager = manager;
    [manager release];
}


- (void)setupRefreshHeaderAndFooter 
{
    // do nothing - no refresh header or footer needed
}


@end
