//
//  AboutViewController.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 5/10/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)contactMeButtonClick:(id)sender
{
    NSString *urlString = @"mailto:zbyhoo@gmail.com?subject=Image of the Day - feedback";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString
       stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (IBAction)myBlogButtonClick:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://zbyhoo.eu"]];
}

@end
