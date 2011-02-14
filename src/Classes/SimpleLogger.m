//
//  ZbyhooLog.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 2/10/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "SimpleLogger.h"


@implementation SimpleLogger

#ifndef NDEBUG
static BOOL enableZbyhooLogging = YES;
#else
static BOOL enableZbyhooLogging = NO;
#endif // NDEBUG

static const char *LOG_TYPE_MSG[] = {"info", "warning", "error", "debug"};

+ (void)log:(char*)file line:(int)line type:(int)type format:(NSString*)format, ...
{	
    va_list argumentList;
	va_start(argumentList,format);
    
	NSString *fileString =[[NSString alloc] initWithBytes:file 
                                            length:strlen(file) 
                                            encoding:NSUTF8StringEncoding];
	NSString *message = [[NSString alloc] initWithFormat:format arguments:argumentList];
    [fileString release];
    
    va_end(argumentList);

    NSString *final = [[NSString alloc] initWithFormat:@"%s:%d: %s: %@", 
                                                        [[fileString lastPathComponent] UTF8String], 
                                                        line, 
                                                        LOG_TYPE_MSG[type], 
                                                        message];
    [SimpleLogger printMessage:final];
	[message release];
}

+ (void)printMessage:(NSString*)message 
{
    NSLog(@"%@", message); // TODO to file also ?
}

+ (void)setLoggingEnabled:(BOOL)enable  { enableZbyhooLogging = enable; }
+ (BOOL)isLoggingEnabled                { return enableZbyhooLogging; }

@end
