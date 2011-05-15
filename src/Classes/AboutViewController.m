//
//  AboutViewController.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 5/10/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "AboutViewController.h"


@implementation AboutViewController

@synthesize webView = _webView;

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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"about_content" ofType:@"html"]; 
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    self.webView.multipleTouchEnabled = NO;
    [[[self.webView subviews] lastObject] setScrollEnabled:NO];
    [self.webView loadHTMLString:content baseURL:nil];
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType; 
{
    NSURL *requestURL =[ [ request URL ] retain ]; 
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ]) 
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) { 
        return ![ [ UIApplication sharedApplication ] openURL: [ requestURL autorelease ] ]; 
    } 
    [ requestURL release ]; 
    return YES; 
}

@end
