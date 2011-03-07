//
//  GDImagePost.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/7/11.
//  Copyright (c) 2011 zbyhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GDPicture;

@interface GDImagePost : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * postDescription;
@property (nonatomic, retain) NSNumber * postDate;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * deleted;
@property (nonatomic, retain) NSNumber * favourite;
@property (nonatomic, retain) NSSet* pictures;

@end
