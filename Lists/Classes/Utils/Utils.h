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
#import "SDWDataModelManager.h"

typedef void (^SDWEmptyBlock)(void);
typedef void (^SDWBooleanBlock)(BOOL result);
typedef void (^SDWResultErrorBlock)(id object, NSError *error);
typedef void (^SDWResultBooleanBlock)(id object, BOOL valid);

@interface Utils : NSObject
@property (nonatomic) SDWDataModelManager *dataModelManager;
+ (NSString *)twoLetterIDFromName:(NSString *)name;
+ (NSDate *)stringToDate:(NSString *)string;
+ (NSString *)dateToString:(NSDate *)date;
+ (NSMenu *)labelsMenuForBoard:(NSString *)trelloID;

@end
