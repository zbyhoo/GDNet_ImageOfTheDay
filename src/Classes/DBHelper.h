//
//  DBHelper.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/9/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

@interface DBHelper : NSObject {
    
}

+ (void)setManagedContext:(NSManagedObjectContext*)context;

- (BOOL)saveContext;
- (BOOL)deleteObject:(NSManagedObject*)object;
- (NSMutableArray*)fetchObjects:(NSString*)name 
                      predicate:(NSPredicate*)predicate 
                        sorting:(NSSortDescriptor*)sorting;
- (NSManagedObject*)createNew:(NSString*)name;
- (void)markModified;
- (void)markUpdated;
- (BOOL)isModified;

@end
