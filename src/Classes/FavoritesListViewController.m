//
//  FavoritesListViewController.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 4/7/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "FavoritesListViewController.h"
#import "FavoritesDataManager.h"
#import "FavoritePostDetailsController.h"

@implementation FavoritesListViewController

- (void)setupDataManager
{
    FavoritesDataManager *manager = [[FavoritesDataManager alloc] init];
    self.dataManager = manager;
    [manager release];
}


- (void)setupRefreshHeaderAndFooter 
{
    // do nothing - no refresh header or footer needed
}

- (PostDetailsController*)allocDetailsViewController
{
    return [[FavoritePostDetailsController alloc] initWithNibName:@"PostDetailsController" bundle:nil];
}

@end
