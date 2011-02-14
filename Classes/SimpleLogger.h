//
//  SimpleLogger.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 2/10/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <Foundation/Foundation.h> 

enum LOG_MESSAGE_TYPE 
{
    LOG_MESSAGE_INFO,
    LOG_MESSAGE_WARNING,
    LOG_MESSAGE_ERROR,
    LOG_MESSAGE_DEBUG       // TODO tracing should be set dynamically 
};

#define Log(t, msg, ...) \
    if ([SimpleLogger isLoggingEnabled] == YES) \
    { \
        [SimpleLogger log:__FILE__ line:__LINE__ type:t format:(msg), ##__VA_ARGS__]; \
    }

#define LogInfo(msg, ...)       Log(LOG_MESSAGE_INFO, msg, ##__VA_ARGS__)
#define LogWarning(msg, ...)    Log(LOG_MESSAGE_WARNING, msg, ##__VA_ARGS__)
#define LogError(msg, ...)      Log(LOG_MESSAGE_ERROR, msg, ##__VA_ARGS__)
#define LogDebug(msg, ...)      Log(LOG_MESSAGE_DEBUG, msg, ##__VA_ARGS__)


@interface SimpleLogger : NSObject {}
+ (void)log:(char*)file line:(int)line type:(int)type format:(NSString*)format, ...;
+ (void)printMessage:(NSString*)message;
+ (void)setLoggingEnabled:(BOOL)enable;
+ (BOOL)isLoggingEnabled;
@end
