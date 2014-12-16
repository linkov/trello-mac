//
//  SDWAppSettings.h
//  Lists
//
//  Created by alex on 11/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#define SharedSettings [SDWAppSettings sharedSettings]
#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>
#import <Crashlytics/Crashlytics.h>

typedef enum {
    SDWDotOptionNoDue = 0,
    SDWDotOptionHasDescription,
    SDWDotOptionOff
} SDWDotOption;


extern NSString * const SDWListsDidReceiveUserTokenNotification;
extern NSString * const SDWListsDidChangeSidebarStatusNotification;
extern NSString * const SDWListsDidChangeCardDetailsStatusNotification;
extern NSString * const SDWListsDidChangeDotOptionNotification;

extern NSString * const SDWListsDidRemoveCardNotification;
extern NSString * const SDWListsShouldFilterNotification;
extern NSString * const SDWListsShouldCreateCardNotification;
extern NSString * const SDWListsDidUpdateDueNotification;

extern NSString * const SDWListsShouldReloadListNotification;
extern NSString * const SDWListsShouldReloadBoardsNotification;


@interface SDWAppSettings : NSObject

+ (instancetype)sharedSettings;

@property BOOL shouldFilter;
@property BOOL shouldFilterDueAccending;
@property BOOL shouldFilterDueDecending;

@property (strong) NSString *userID;
@property (strong) NSString *userToken;
@property (strong,nonatomic) NSString *appToken;
@property (strong) NSArray *selectedListUsers;
@property (strong) NSString *lastSelectedList;

@property SDWDotOption dotOption;

@property (strong) NSSet *collapsedBoardsIDs;

- (NSColor *)appBleakWhiteColor;
- (NSColor *)appBackgroundColorDark;
- (NSColor *)appBackgroundColor;
- (NSColor *)appHighlightColor;
- (NSColor *)appHighlightGreenColor;
- (NSColor *)appSelectionColor;
- (NSColor *)appUIColor;

@end
