//
//  SDWLogger.m
//  Lists
//
//  Created by alex on 5/16/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWLogger.h"

@implementation SDWLogger

static SDWLogger *sharedLogger;
+ (instancetype)sharedLogger {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLogger = [SDWLogger new];
    });
    return sharedLogger;
}

- (void)logError:(NSString *)format, ...NS_FORMAT_FUNCTION(1, 2) {
    va_list args;
    va_start(args, format);

    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    NSLog(@"\n[ERROR] %@\n", message);

    va_end(args);
}

@end
