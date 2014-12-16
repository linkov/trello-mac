//
//  SDWAppSettings.m
//  Lists
//
//  Created by alex on 11/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//


#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

#define defaults                                [NSUserDefaults standardUserDefaults]
#define saveDefaults()                          [defaults synchronize]

#define setBoolForKey(value, key)               [defaults setBool:value forKey:key]
#define setObjectForKey(object, key)            [defaults setObject:object forKey:key]

#define setBoolForKeyAndSave(value, key)        setBoolForKey(value, key); saveDefaults()
#define setObjectForKeyAndSave(object, key)     setObjectForKey(object, key);  saveDefaults()

#define objectForKey(key)                       [defaults objectForKey:key]
#define boolForKey(key)                         [defaults boolForKey:key]

#define valueForKeyExists(key)                  objectForKey(key) != nil

NSString * const SDWListsDidReceiveUserTokenNotification  =  @"com.sdwr.trello-mac.didReceiveUserTokenNotification";
NSString * const SDWListsDidChangeSidebarStatusNotification  =  @"com.sdwr.trello-mac.didChangeSidebarStatusNotification";
NSString * const SDWListsDidChangeCardDetailsStatusNotification  =  @"com.sdwr.trello-mac.didChangeCardDetailsStatusNotification";

NSString * const SDWListsDidRemoveCardNotification = @"com.sdwr.trello-mac.didRemoveCardNotification";
NSString * const SDWListsShouldFilterNotification = @"com.sdwr.trello-mac.shouldFilterNotification";
NSString * const SDWListsDidUpdateDueNotification = @"com.sdwr.trello-mac.didUpdateDueNotification";



NSString * const SDWListsShouldCreateCardNotification = @"com.sdwr.trello-mac.shouldCreateCardNotification";
NSString * const SDWListsShouldReloadListNotification = @"com.sdwr.trello-mac.shouldReloadListNotification";
NSString * const SDWListsShouldReloadBoardsNotification = @"com.sdwr.trello-mac.shouldReloadBoardsNotification";

#import "NSColor+Util.h"
#import "SDWAppSettings.h"

@implementation SDWAppSettings {

    NSSet *_collapsedBoardsIDs;
}


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

- (NSColor *)appUIColor {

    return [NSColor colorWithHexColorString:@"4F778A"];
}

- (NSColor *)appBleakWhiteColor {

    return [NSColor colorWithHexColorString:@"E8E8E8"];
}

- (NSColor *)appHighlightColor {

    return [NSColor colorWithHexColorString:@"3E6378"];
}

- (NSColor *)appBackgroundColorDark {

    return [NSColor colorWithCalibratedRed:0.096 green:0.265 blue:0.387 alpha:1.000];
}



- (void)setCollapsedBoardsIDs:(NSSet *)collapsedBoardsIDs {
    _collapsedBoardsIDs = collapsedBoardsIDs;
    [self saveCustomObject:collapsedBoardsIDs forKey:@"collapsedBoards"];
}

- (NSSet *)collapsedBoardsIDs {
    if (!_collapsedBoardsIDs) {
        _collapsedBoardsIDs = [self customObjectForKey:@"collapsedBoards"];
    }
    return _collapsedBoardsIDs;
}


#pragma mark - Helpers

- (void)saveCustomObject:(id)object forKey:(NSString *)key {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    setObjectForKeyAndSave(data, key);
}

- (id)customObjectForKey:(NSString *)key {
    NSData *data = objectForKey(key);
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
