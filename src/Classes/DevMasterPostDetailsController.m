//
//  DevMasterPostDetailsController.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 5/9/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "DevMasterPostDetailsController.h"
#import "DevMasterDataManager.h"

@implementation DevMasterPostDetailsController

- (void)setupDataManager
{
    DevMasterDataManager *manager = [[DevMasterDataManager alloc] init];
    self.dataManager = manager;
    [manager release];
}

@end
