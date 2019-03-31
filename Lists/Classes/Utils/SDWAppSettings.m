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
NSString * const SDWListsDidChangeDotOptionNotification =  @"com.sdwr.trello-mac.didChangeDotOptionNotification";

NSString * const SDWListsDidRemoveCardNotification = @"com.sdwr.trello-mac.didRemoveCardNotification";
NSString * const SDWListsShouldFilterNotification = @"com.sdwr.trello-mac.shouldFilterNotification";
NSString * const SDWListsDidUpdateDueNotification = @"com.sdwr.trello-mac.didUpdateDueNotification";

NSString * const SDWListsDidReceiveNetworkOffNotification = @"com.sdwr.trello-mac.SDWListsDidReceiveNetworkOffNotification";
NSString * const SDWListsDidReceiveNetworkOnNotification = @"com.sdwr.trello-mac.SDWListsDidReceiveNetworkOnNotification";

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

- (void)setTodayListID:(NSString *)listID {
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"com.sdwr.lists.appgroup"];
    [shared setObject:listID forKey:@"com.sdwr.trello-mac.todaylistID"];
    [shared synchronize];
}

- (void)setTodayListName:(NSString *)listName {
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"com.sdwr.lists.appgroup"];
    [shared setObject:listName forKey:@"com.sdwr.trello-mac.todaylistName"];
    [shared synchronize];
}

- (NSString *)appToken {

    return @"6825229a76db5b6a5737eb97e9c4a923";
}

- (void)setOffline:(BOOL)offline {
    
    
    [[NSUserDefaults standardUserDefaults] setBool:offline forKey:@"com.sdwr.trello-mac.offline"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)isOffline {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"com.sdwr.trello-mac.offline"];
}



- (void)setUserToken:(NSString *)userToken {

    self.lastSelectedList = nil;

    [[NSUserDefaults standardUserDefaults] setObject:userToken forKey:@"com.sdwr.trello-mac.token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"com.sdwr.lists.appgroup"];
    [shared setObject:userToken forKey:@"com.sdwr.trello-mac.userToken"];
    [shared synchronize];
    
}

- (NSString *)userToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"com.sdwr.trello-mac.token"];
}

- (void)setShouldShowCardLabels:(BOOL)shouldShowCardLabels {

    [[NSUserDefaults standardUserDefaults] setBool:shouldShowCardLabels forKey:@"com.sdwr.trello-mac.showLabels"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)shouldShowCardLabels {

    return [[NSUserDefaults standardUserDefaults] boolForKey:@"com.sdwr.trello-mac.showLabels"];
}

- (void)setDotOption:(SDWDotOption)dotOption {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:dotOption] forKey:@"com.sdwr.trello-mac.dotOption"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (SDWDotOption)dotOption {
    NSNumber *dotOption = [[NSUserDefaults standardUserDefaults] objectForKey:@"com.sdwr.trello-mac.dotOption"];
    return [dotOption intValue];
}


- (void)setUserID:(NSString *)userID {
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"com.sdwr.trello-mac.userID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)userID {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"com.sdwr.trello-mac.userID"];
}


- (NSColor *)appBackgroundColor {

   return [NSColor colorWithHexColorString:@"E2E4E6"];
}

- (NSColor *)appSelectionColor {

    return [NSColor colorWithHexColorString:@"D9E4EB"];
}


- (NSColor *)appHighlightGreenColor {
    return [NSColor colorWithHexColorString:@"3DB8DE"];
}

- (NSColor *)appUIColor {

    return [NSColor colorWithHexColorString:@"4F778A"];
}

- (NSColor *)appBleakWhiteColor {

    return [NSColor colorWithHexColorString:@"30364C"];
}

- (NSColor *)appHighlightColor {

    return [NSColor colorWithHexColorString:@"D9E4EB"];
}

- (NSColor *)appBackgroundColorDark {

    return [NSColor colorWithHexColorString:@"EDEFF0"];
}

- (NSColor *)dotColor {
    
    return [NSColor colorWithHexColorString:@"30364C"];
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
- (NSColor *)colorWithAlphaForTrelloColor:(NSColor *)color {

    return [color colorWithAlphaComponent:0.4];
}

- (NSColor *)colorForTrelloColor:(NSString *)colorString {

    NSColor *color;

    if ([colorString isEqualToString:@"green"]) {

        color = [NSColor colorWithHexColorString:@"417505"];

    } else if ([colorString isEqualToString:@"yellow"]) {

        color = [NSColor colorWithHexColorString:@"F8CA00"];

    } else if ([colorString isEqualToString:@"orange"]) {

        color = [NSColor orangeColor];

    } else if ([colorString isEqualToString:@"red"]) {

        color = [NSColor redColor];

    } else if ([colorString isEqualToString:@"blue"]) {

        color = [NSColor blueColor];

    } else if ([colorString isEqualToString:@"purple"]) {

        color = [NSColor purpleColor];

    }



    else if ([colorString isEqualToString:@"black"]) {

        color = [NSColor colorWithHexColorString:@"4d4d4d"];
    }

    else if ([colorString isEqualToString:@"lime"]) {

        color = [NSColor colorWithHexColorString:@"7aecae"];
    }


    else if ([colorString isEqualToString:@"pink"]) {

        color = [NSColor colorWithHexColorString:@"fd7bca"];
    }


    else if ([colorString isEqualToString:@"sky"]) {

        color = [NSColor colorWithHexColorString:@"20c2de"];
    }



    return [color colorWithAlphaComponent:0.6];
}

- (void)saveCustomObject:(id)object forKey:(NSString *)key {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    setObjectForKeyAndSave(data, key);
}

- (id)customObjectForKey:(NSString *)key {
    NSData *data = objectForKey(key);
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
