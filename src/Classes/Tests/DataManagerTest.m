//
//  DataManagerTest.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/14/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "../DataManager.h"
#import "../GDImagePost.h"
#import "../DBHelper.h"
#import "../GDArchiveHtmlStringConverter.h"

@interface DataManagerTest : GHTestCase {
@private
    DataManager *_dataManager;
}
@property (nonatomic, retain) DataManager *dataManager;
@end

@implementation DataManagerTest

@synthesize dataManager = _dataManager;

- (void)setUp {
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:nil];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    GHAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");    
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
    moc.persistentStoreCoordinator = psc;
    
    [DBHelper setManagedContext:moc];
    
    [moc release];
    [mom release];
    [psc release];
    
    DBHelper *dbHelper = [[DBHelper alloc] init];
    DataManager *dataManager = [[DataManager alloc] initWithDataType:POST_NORMAL dbHelper:dbHelper];
    self.dataManager = dataManager;
    [dataManager release];
    [dbHelper release];
}

- (void)tearDown {
    self.dataManager = nil;
}

@end
