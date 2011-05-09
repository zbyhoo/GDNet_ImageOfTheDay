//
//  GameDevArchiveListViewController.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 5/9/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "GameDevArchiveListViewController.h"
#import "GameDevArchiveDataManager.h"
#import "GameDevArchivePostDetailsController.h"

@implementation GameDevArchiveListViewController

- (void)setupDataManager
{
    GameDevArchiveDataManager *manager = [[GameDevArchiveDataManager alloc] init];
    self.dataManager = manager;
    [manager release];
}

- (PostDetailsController*)allocDetailsViewController
{
    return [[GameDevArchivePostDetailsController alloc] initWithNibName:@"PostDetailsController" bundle:nil];
}

@end
