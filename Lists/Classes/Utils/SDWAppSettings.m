//
//  SDWAppSettings.m
//  Lists
//
//  Created by alex on 11/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

NSString * const SDWListsDidReceiveUserTokenNotification  =  @"com.sdwr.trello-mac.didReceiveUserTokenNotification";
NSString * const SDWListsDidChangeSidebarStatusNotification  =  @"com.sdwr.trello-mac.didChangeSidebarStatusNotification";

NSString * const SDWListsShouldRemoveCardNotification = @"com.sdwr.trello-mac.shouldRemoveCardNotification";
NSString * const SDWListsDidRemoveCardNotification = @"com.sdwr.trello-mac.didRemoveCardNotification";
NSString * const SDWListsShouldFilterNotification = @"com.sdwr.trello-mac.shouldFilterNotification";

NSString * const SDWListsShouldCreateCardNotification = @"com.sdwr.trello-mac.shouldCreateCardNotification";
NSString * const SDWListsShouldReloadListNotification = @"com.sdwr.trello-mac.shouldReloadListNotification";
NSString * const SDWListsShouldReloadBoardsNotification = @"com.sdwr.trello-mac.shouldReloadBoardsNotification";

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

    self.lastSelectedList = nil;

    [[NSUserDefaults standardUserDefaults] setObject:userToken forKey:@"com.sdwr.trello-mac.token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (NSString *)userToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"com.sdwr.trello-mac.token"];
}


- (void)setUserID:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"com.sdwr.trello-mac.userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)userID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"com.sdwr.trello-mac.userID"];
}


- (NSColor *)appBackgroundColor {

   return [NSColor colorWithHexColorString:@"1E5676"];
}

- (NSColor *)appSelectionColor {

    return [NSColor colorWithHexColorString:@"deeef4"];
}


- (NSColor *)appHighlightGreenColor {
    return [NSColor colorWithHexColorString:@"1D8722"];
}

- (NSColor *)appHighlightColor {

    return [NSColor colorWithHexColorString:@"3E6378"];
}

- (NSColor *)appBackgroundColorDark {

    return [NSColor colorWithCalibratedRed:0.096 green:0.265 blue:0.387 alpha:1.000];
}

@end