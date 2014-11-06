//
//  SDWAppSettings.m
//  Vector
//
//  Created by alex on 11/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+Util.h"
#import "SDWAppSettings.h"

@implementation SDWAppSettings


static SDWAppSettings *sharedInstance = nil;

+ (instancetype)sharedSettings {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [SDWAppSettings new];
    });
    return sharedInstance;
}

- (NSString *)appToken {

    return @"6825229a76db5b6a5737eb97e9c4a923";
}

- (void)setUserToken:(NSString *)userToken {

    [[NSUserDefaults standardUserDefaults] setObject:userToken forKey:@"com.sdwr.trello-mac.token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)userToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"com.sdwr.trello-mac.token"];
}

- (NSColor *)appBackgroundColor {

   return [NSColor colorWithHexColorString:@"1E5676"];
}

- (NSColor *)appHighlightColor {

    return [NSColor colorWithHexColorString:@"3E6378"];
}

- (NSColor *)appBackgroundColorDark {

    return [NSColor colorWithCalibratedRed:0.096 green:0.265 blue:0.387 alpha:1.000];
}

@end
