//
//  ZoomedImageViewController.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/23/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

@interface ZoomedImageViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *_scrollView;
    UIImage *_image;
}

- (id)initWithImage:(UIImage*)image;

@end
