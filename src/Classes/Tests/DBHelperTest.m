//
//  DBHelperTest.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/18/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "../DBHelper.h"

@interface DBHelperTest : GHTestCase {
@private
    DBHelper *_dbHelper;
}
@property (nonatomic, retain) DBHelper *dbHelper;
@end

@implementation DBHelperTest

@synthesize dbHelper = _dbHelper;

- (void)setUp {
    NSManagedObjectModel *mom = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    GHAssertTrue([psc addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Should be able to add in-memory store");    
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
    moc.persistentStoreCoordinator = psc;
    
    [DBHelper setManagedContext:moc];
    
    [moc release];
    [psc release];
    [mom release];
    
    DBHelper *dbHelper = [[DBHelper alloc] init];
    self.dbHelper = dbHelper;
    [dbHelper release];
}

- (void)tearDown {
    self.dbHelper = nil;
    [DBHelper setManagedContext:nil];
}

- (void)test_isModified_atInitialization {
    
    // given
    
    // when
    BOOL modified = [self.dbHelper isModified];
    
    // then
    GHAssertFalse(modified, @"initial value of modified");
}

- (void)test_markModified {
    
    // given
    GHAssertFalse([self.dbHelper isModified], @"initial criteria");
    
    // when
    [self.dbHelper markModified];
    BOOL modified = [self.dbHelper isModified];
    
    // then
    GHAssertTrue(modified, @"after marking as modified");
}

- (void)test_markUpdated {
    
    // given
    [self.dbHelper markModified];
    GHAssertTrue([self.dbHelper isModified], @"initial criteria");
    
    // when
    [self.dbHelper markUpdated];
    BOOL modified = [self.dbHelper isModified];
    
    // then
    GHAssertFalse(modified, @"after marking as updated");
}

- (void)test_createNew_GDImagePost {
    
    // given
    NSString *objectName = @"GDImagePost";
    
    // when
    NSManagedObject *object = [self.dbHelper createNew:objectName];
    
    // then
    GHAssertNotNil(object, @"returned object");
}

- (void)test_createNew_GDPicture {
    
    // given
    NSString *objectName = @"GDPicture";
    
    // when
    NSManagedObject *object = [self.dbHelper createNew:objectName];
    
    // then
    GHAssertNotNil(object, @"returned object");
}

- (void)test_createNew_notExistingObjectName {
    
    // given
    NSString *objectName    = @"notExistingObjectName";
    NSManagedObject *object = nil;
    BOOL exceptionCatched   = NO;
    
    // when
    @try {
        object = [self.dbHelper createNew:objectName];
    }
    @catch (NSException *exception) {
        if ([[exception name] isEqualToString:NSInternalInconsistencyException]) {
            exceptionCatched = YES;
        }
        else {
            @throw exception;
        }
    }
    
    // then
    GHAssertTrue(exceptionCatched, @"exception catched");
    GHAssertNil(object, @"no object returned");
}

@end
