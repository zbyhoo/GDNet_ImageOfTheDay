//
//  DBHelper.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/9/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "DBHelper.h"


@implementation DBHelper

NSManagedObjectContext *managedObjectContext = nil;
BOOL dataModified = NO;

+ (void)setManagedContext:(NSManagedObjectContext*)context {
    if (managedObjectContext != nil) {
        [managedObjectContext release];
    }
    managedObjectContext = [context retain];
}

- (BOOL)saveContext {
    NSError* error;
    if (![managedObjectContext save:&error]) {
        LogError(@"error saving managed context:\n%@", [error userInfo]);
        return NO;
    }
    return YES;
}

- (BOOL)deleteObject:(NSManagedObject*)object {
    [managedObjectContext deleteObject:object];
    return [self saveContext];
}

- (NSMutableArray*)fetchObjects:(NSString*)name 
                      predicate:(NSPredicate*)predicate 
                        sorting:(NSSortDescriptor*)sorting {

    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:name 
                                              inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    if (predicate) {
        [request setPredicate:predicate];
    }
    if (sorting) {
        [request setSortDescriptors:[NSArray arrayWithObject:sorting]];
    }
        
    NSError *error = nil;
    NSArray *array = [managedObjectContext executeFetchRequest:request error:&error];
    [request release];
    if (array == nil) {
        LogError(@"error fetching request:\n%@", [error userInfo]);
        return nil;
    }
    LogDebug(@"number of posts fetched: %d", [array count]);
    return [NSMutableArray arrayWithArray:array];
}

- (NSManagedObject*)createNew:(NSString*)name {
    return [NSEntityDescription 
            insertNewObjectForEntityForName:name 
            inManagedObjectContext:managedObjectContext];
}

- (void)markModified {
    dataModified = YES;
}

- (void)markUpdated {
    dataModified = NO;
}

- (BOOL)isModified {
    return dataModified;
}

@end
