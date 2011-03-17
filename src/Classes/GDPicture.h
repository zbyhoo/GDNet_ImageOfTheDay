//
//  GDPicture.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/17/11.
//  Copyright (c) 2011 zbyhoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GDImagePost;

@interface GDPicture : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * smallPictureUrl;
@property (nonatomic, retain) NSData * largePictureData;
@property (nonatomic, retain) NSString * pictureDescription;
@property (nonatomic, retain) NSData * smallPictureData;
@property (nonatomic, retain) NSString * largePictureUrl;
@property (nonatomic, retain) GDImagePost * imagePost;

@end
