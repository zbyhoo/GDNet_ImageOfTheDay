//
//  DataManagerTest.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/14/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "../DataManager.h"
#import "FavoritesDataManager.h"
#import "../GDImagePost.h"
#import "../DBHelper.h"
#import "../GDArchiveHtmlStringConverter.h"

#import <objc/objc.h>
#import <objc/runtime.h>
#import <objc/message.h>

@interface DataManagerTest : GHTestCase {
}
@end

@implementation DataManagerTest

- (void)test_getDateSortDescriptor {
    
    // given
    DataManager *manager = [[[DataManager alloc] init] autorelease];
    
    // when
    NSSortDescriptor *descriptor = [manager getDateSortDescriptor];
    
    // then
    GHAssertNotNil(descriptor, @"descriptor created");
    GHAssertEquals([descriptor retainCount], (NSUInteger)1, @"retain counter");
    GHAssertEqualStrings([descriptor key], @"postDate", @"proper date descriptor's key");
}

- (void)test_getPredicateWithDeletedAndFavorite_notDeletedNotFavorite {
    
    // given
    DataManager *manager = [[[DataManager alloc] init] autorelease];
    
    // when
    NSPredicate *predicate = [manager getPredicateWithDeleted:NO];
    
    // then
    GHAssertNotNil(predicate, @"predicate created");
    GHAssertEqualStrings([predicate predicateFormat], @"deleted == 0 AND favourite == 0", @"proper predicate format");
}

- (void)test_getPredicateWithDeletedAndFavorite_deletedFavorite {
    
    // given
    FavoritesDataManager *manager = [[[FavoritesDataManager alloc] init] autorelease];
    
    // when
    NSPredicate *predicate = [manager getPredicateWithDeleted:YES];
    
    // then
    GHAssertNotNil(predicate, @"predicate created");
    GHAssertEqualStrings([predicate predicateFormat], @"deleted == 1 AND favourite == 1", @"proper predicate format");
}

- (void)test_shouldDownloadData_positive {
    
    // given
    DataManager *manager = [[[DataManager alloc] init] autorelease];
    
    // when
    BOOL shouldDownload = [manager shouldDownloadData];
    
    // then
    GHAssertTrue(shouldDownload, @"should download data");
}

- (NSArray*)getPostsMock {

    return [[NSMutableArray alloc] initWithObjects:@"single object", nil];
}

- (void)test_shouldDownloadData_postCountGreaterThenZero {
    
    // given
    DataManager *manager = [[[DataManager alloc] init] autorelease];
    Method m1 = class_getInstanceMethod(manager.class, @selector(posts));
    Method m2 = class_getInstanceMethod(self.class, @selector(getPostsMock));
    method_exchangeImplementations(m1, m2);
    GHAssertEquals(manager.posts.count, (NSUInteger)1, @"mocked posts count");
    
    // when
    BOOL shouldDownload = [manager shouldDownloadData];
    
    // then
    GHAssertFalse(shouldDownload, @"should not download data");
}

- (void)test_shouldDownloadData_favoritePostsType {
    
    // given
    FavoritesDataManager *manager = [[[FavoritesDataManager alloc] init] autorelease];
    GHAssertEquals(manager.posts.count, (NSUInteger)0, @"no posts");
    
    // when
    BOOL shouldDownload = [manager shouldDownloadData];
    
    // then
    GHAssertFalse(shouldDownload, @"should not download data");
}

@end
