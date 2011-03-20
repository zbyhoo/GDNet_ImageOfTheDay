//
//  WebView.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/20/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "WebView.h"


@implementation WebView

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {	

	NSSet *touches = [event allTouches];
	BOOL forwardToSuper = YES;
    
    if (time == (int)event.timestamp) {
        // prevent this 
        forwardToSuper = NO;
    }
    time = event.timestamp;
    
    if ([touches count] > 1) {
        forwardToSuper = NO;
    }
	for (UITouch *touch in touches) {
		if ([touch tapCount] >= 2) {
			forwardToSuper = NO;
		}		
	}
    
	if (forwardToSuper){
		return [super hitTest:point withEvent:event];
	}
	else {
		// Return the superview as the hit and prevent
		// UIWebView receiving double or more taps
		return self;
	}
}

@end
