//
//  GDArchiveHtmlStringConverter.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 2/16/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "GDHtmlStringConverter.h"

@interface GDArchiveHtmlStringConverter : GDHtmlStringConverter 
{
@private
    NSString *_templateUrl;
    int _currentPage;
}

- (void)resetUrlCounter;
- (NSString*)getNextUrl;

@end
