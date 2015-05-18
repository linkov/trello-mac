//
//  SDWLogger.h
//  Lists
//
//  Created by alex on 5/16/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SDWLogError(frmt, ...) [[SDWLogger sharedLogger] logError : (frmt), ## __VA_ARGS__];

@interface SDWLogger : NSObject

+ (instancetype)sharedLogger;

- (void)logError:(NSString *)format, ...NS_FORMAT_FUNCTION(1, 2);

@end
