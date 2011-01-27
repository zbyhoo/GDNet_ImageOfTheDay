//
//  GDImagePost.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/27/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <CoreData/CoreData.h>

@class GDPicture;

@interface GDImagePost :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * postDate;
@property (nonatomic, retain) NSString * postDescription;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet* pictures;

@end


@interface GDImagePost (CoreDataGeneratedAccessors)
- (void)addPicturesObject:(GDPicture *)value;
- (void)removePicturesObject:(GDPicture *)value;
- (void)addPictures:(NSSet *)value;
- (void)removePictures:(NSSet *)value;

@end

