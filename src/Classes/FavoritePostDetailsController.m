//
//  FavoritePostDetailsController.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 4/7/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "FavoritePostDetailsController.h"
#import "FavoritesDataManager.h"

@implementation FavoritePostDetailsController

- (void)setupDataManager
{
    FavoritesDataManager *manager = [[FavoritesDataManager alloc] init];
    self.dataManager = manager;
    [manager release];
}

- (NSString*)getFavoriteString
{
    return @"Remove from Favorites";
}

- (void)favoriteButtonSelected 
{    
    GDImagePost *post = [self.dataManager getPostWithId:self.postId];
    [self.dataManager removePostFromFavorites:post];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
