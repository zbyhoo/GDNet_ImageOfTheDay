//
//  GDPicture.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface GDPicture :  NSManagedObject  
{
}

@property (nonatomic, retain) NSData * largePictureData;
@property (nonatomic, retain) NSString * smallPictureUrl;
@property (nonatomic, retain) NSString * pictureDescription;
@property (nonatomic, retain) NSData * smallPictureData;
@property (nonatomic, retain) NSString * largePictureUrl;
@property (nonatomic, retain) NSManagedObject * imagePost;

@end



