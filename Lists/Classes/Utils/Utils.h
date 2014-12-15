//
//  Utils.h
//  Lists
//
//  Created by alex on 11/8/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (NSString *)twoLetterIDFromName:(NSString *)name;
+ (NSDate *)stringToDate:(NSString *)string;
+ (NSString *)dateToString:(NSDate *)date;

@end
