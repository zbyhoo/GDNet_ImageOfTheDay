//
//  AboutViewController.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 5/10/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutViewController : UIViewController <UIWebViewDelegate>
{
@protected
    IBOutlet UIWebView *_webView;
}

@property (nonatomic, retain) UIWebView *webView;

@end
