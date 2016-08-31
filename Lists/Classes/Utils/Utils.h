//
//  Utils.h
//  Lists
//
//  Created by alex on 11/8/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "NSImage+Util.h"
#import "SDWAppSettings.h"


typedef void (^SDWEmptyBlock)();
typedef void (^SDWBooleanBlock)(BOOL result);
typedef void (^SDWResultErrorBlock)(id object, NSError *error);
typedef void (^SDWResultBooleanBlock)(id object, BOOL valid);

@interface Utils : NSObject

+ (NSString *)twoLetterIDFromName:(NSString *)name;
+ (NSDate *)stringToDate:(NSString *)string;
+ (NSString *)dateToString:(NSDate *)date;
+ (NSMenu *)labelsMenu;

@end
