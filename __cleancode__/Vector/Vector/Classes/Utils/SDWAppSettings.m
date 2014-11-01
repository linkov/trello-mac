//
//  SDWAppSettings.m
//  Vector
//
//  Created by alex on 11/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

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


@end
