//
//  PostDetailsController.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/16/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataManager;
@class GDImagePost;
@class ImagesViewCell;
@class DescriptionViewCell;

@interface PostDetailsController : UITableViewController {
@private
    DataManager *_dataManager;
    NSString *_postId;    
    
    IBOutlet ImagesViewCell *_imagesCell;
    IBOutlet DescriptionViewCell *_descriptionCell;
}

@property (nonatomic, retain) DataManager *dataManager;
@property (nonatomic, retain) NSString *postId;
@property (nonatomic, retain) ImagesViewCell *imagesCell;
@property (nonatomic, retain) DescriptionViewCell *descriptionCell;

- (void)updateView:(GDImagePost*)post;

@end
