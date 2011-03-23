//
//  ZoomedImageViewController.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/23/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "ZoomedImageViewController.h"


@implementation ZoomedImageViewController

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
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:_image];
    
    _scrollView.contentSize = CGSizeMake(imageView.frame.size.width, imageView.frame.size.height);
    _scrollView.maximumZoomScale = 4.0;
    _scrollView.minimumZoomScale = 0.5;
    _scrollView.clipsToBounds = YES;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor blackColor];
    
    [_scrollView addSubview:imageView];
    [imageView release];
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

@end
