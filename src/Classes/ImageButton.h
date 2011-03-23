//
//  ImageButton.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/23/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

@class GDPicture;

@interface ImageButton : UIButton {
@private
    GDPicture *_picture;
}

@property (nonatomic, retain) GDPicture *picture;

@end
