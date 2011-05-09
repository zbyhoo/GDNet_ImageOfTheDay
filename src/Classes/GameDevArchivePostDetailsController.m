//
//  GameDevArchivePostDetailsController.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 5/9/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "GameDevArchivePostDetailsController.h"
#import "GameDevArchiveDataManager.h"

@implementation GameDevArchivePostDetailsController

- (void)setupDataManager
{
    GameDevArchiveDataManager *manager = [[GameDevArchiveDataManager alloc] init];
    self.dataManager = manager;
    [manager release];
}

@end
