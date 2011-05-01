//
//  DevMasterHtmlConverter.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 4/26/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "GDHtmlStringConverter.h"

@interface DevMasterHtmlConverter : GDHtmlStringConverter 
{    
@protected
    NSString *_templateUrl;
    int _currentPage;
    int _step;
}

@property (nonatomic, readonly) NSString *templateUrl;
@property (nonatomic, readonly) int step;
@property (nonatomic, readonly) int currentPage;

- (NSNumber*)convertPostExactDate:(NSString*)dateString;
- (NSNumber*)stringToTimestamp:(NSString*)dateString;

@end
