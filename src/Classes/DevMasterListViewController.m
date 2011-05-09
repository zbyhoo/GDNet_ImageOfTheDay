//
//  DevMasterListViewController.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 5/3/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "DevMasterListViewController.h"
#import "DevMasterDataManager.h"
#import "DevMasterPostDetailsController.h"

@implementation DevMasterListViewController

- (void)setupDataManager
{
    DevMasterDataManager *manager = [[DevMasterDataManager alloc] init];
    self.dataManager = manager;
    [manager release];
}

- (PostDetailsController*)allocDetailsViewController
{
    return [[DevMasterPostDetailsController alloc] initWithNibName:@"PostDetailsController" bundle:nil];
}

@end
