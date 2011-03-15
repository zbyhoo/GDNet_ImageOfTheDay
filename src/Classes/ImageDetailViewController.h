//
//  ImageDetailViewController.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 1/26/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDImagePost.h"

@class DataManager;

@interface ImageDetailViewController : UIViewController {
    IBOutlet UIWebView *_descriptionView;
@private
    DataManager *_dataManager;
    NSString *_postId;
}

@property (nonatomic, retain) UIWebView *descriptionView;
@property (nonatomic, retain) NSString *postId;

- (void)updateView:(GDImagePost*)post;

@end
