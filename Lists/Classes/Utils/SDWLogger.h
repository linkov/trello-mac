//
//  SDWLogger.h
//  Lists
//
//  Created by alex on 5/16/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SDWLog [SDWLogger sharedLogger]

@interface SDWLogger : NSObject

+ (instancetype)sharedLogger;

- (void)logError:(NSString *)error;

@end
