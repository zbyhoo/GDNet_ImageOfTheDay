//
//  ZoomedImageViewController.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/23/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "ZoomedImageViewController.h"


@implementation ZoomedImageViewController

@synthesize imageView = _imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithImage:(UIImage*)image {
    self = [super init];
    if (self) {
        _image = [image retain];
    }
    return self;
}

- (void)dealloc
{
    [_image release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
    self.imageView = imageView;
    [imageView release];
    
    _scrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
    _scrollView.maximumZoomScale = 4.0;
    _scrollView.minimumZoomScale = 0.5;
    _scrollView.clipsToBounds = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor blackColor];
    
    [_scrollView addSubview:self.imageView];
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGesture:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    doubleTap.delaysTouchesBegan = YES;
        
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    singleTap.delaysTouchesBegan = YES;
    [singleTap requireGestureRecognizerToFail:doubleTap];

    [_scrollView addGestureRecognizer:singleTap];
    [_scrollView addGestureRecognizer:doubleTap];
    [singleTap release];
    [doubleTap release];
    

}

- (void) hideTabBar:(BOOL)hidden {
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.35];
    
    for(UIView *view in self.navigationController.tabBarController.view.subviews) {
        if([view isKindOfClass:[UITabBar class]]) {
            if (!hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, 480, view.frame.size.width, view.frame.size.height)];
            }
        } 
        else {
            if (!hidden) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
            } else {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 480)];
            }
        }
    }
    
    [UIView commitAnimations];
}

- (void)doubleTapGesture:(UIGestureRecognizer*)gesture {

    LogDebug(@"double tap");
    
    //[_scrollView scrollRectToVisible:self.imageView.frame animated:YES];
}

- (void)singleTapGesture:(UIGestureRecognizer*)gesture {

    LogDebug(@"single tap");
    
    BOOL hidden = ! self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:hidden animated:YES];
    
    [self hideTabBar:hidden];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
