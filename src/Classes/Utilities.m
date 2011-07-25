//
//  Utilities.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/2/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "Utilities.h"


@implementation Utilities

+ (NSString*)getSubstringFrom:(NSString*)string range:(NSRange*)range after:(NSString*)after before:(NSString*)before 
{    
    if ((*range).length >= string.length) 
    {
        return nil;
    }
    
    (*range) = [string rangeOfString:after options:0 range:(*range)];
    
    if ((*range).location > string.length) 
    {
        return nil;
    }
    
    (*range).length = string.length - (*range).location - after.length;
    (*range).location += after.length;
    
    NSRange final;
    final.location = (*range).location;
    
    (*range) = [string rangeOfString:before options:0 range:(*range)];
    
    if ((*range).location > string.length - 1 || (*range).location < final.location) 
    {
        return nil;
    }
    
    final.length = (*range).location - final.location;
    
    (*range).length = string.length - (*range).location - before.length;
    (*range).location += before.length;
    
    return [string substringWithRange:final];
}

+ (CGRect) getResizedFrameForImage:(UIImage*)image withCurrentFrame:(CGRect)frame
{
    CGRect newFrame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGFloat resizeRatio = frame.size.width / image.size.width;
    newFrame.size.width *= resizeRatio;
    newFrame.size.height *= resizeRatio;
    
    if (newFrame.size.height > frame.size.height)
    {
        resizeRatio = frame.size.height / newFrame.size.height;
        newFrame.size.width *= resizeRatio;
        newFrame.size.height *= resizeRatio;
    }
    
    newFrame.origin.x = (frame.size.width - newFrame.size.width) / 2.0f;
    newFrame.origin.y = (frame.size.height - newFrame.size.height) / 2.0f;
    
    return newFrame;
}

@end
