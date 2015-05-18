//
//  Constants.m
//  Lists
//
//  Created by alex on 5/16/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "Constants.h"

/* notifications */
NSString *const SDWListsDidReceiveUserTokenNotification = @"com.sdwr.trello-mac.didReceiveUserTokenNotification";
NSString *const SDWListsDidChangeSidebarStatusNotification = @"com.sdwr.trello-mac.didChangeSidebarStatusNotification";
NSString *const SDWListsDidChangeCardDetailsStatusNotification = @"com.sdwr.trello-mac.didChangeCardDetailsStatusNotification";
NSString *const SDWListsDidChangeDotOptionNotification = @"com.sdwr.trello-mac.didChangeDotOptionNotification";

NSString *const SDWListsDidRemoveCardNotification = @"com.sdwr.trello-mac.didRemoveCardNotification";
NSString *const SDWListsShouldFilterNotification = @"com.sdwr.trello-mac.shouldFilterNotification";
NSString *const SDWListsDidUpdateDueNotification = @"com.sdwr.trello-mac.didUpdateDueNotification";

NSString *const SDWListsShouldCreateCardNotification = @"com.sdwr.trello-mac.shouldCreateCardNotification";
NSString *const SDWListsShouldReloadListNotification = @"com.sdwr.trello-mac.shouldReloadListNotification";
NSString *const SDWListsShouldReloadBoardsNotification = @"com.sdwr.trello-mac.shouldReloadBoardsNotification";

/* defaults */
NSString *const SDWListsShouldCrownFilterKey = @"com.sdwr.trello-mac.SDWListsShouldCrownFilterKey";
NSString *const SDWListsShouldFilterDueAccendingKey = @"com.sdwr.trello-mac.SDWListsShouldFilterDueAccendingKey";
NSString *const SDWListsShouldFilterDueDecendingKey = @"com.sdwr.trello-mac.SDWListsShouldFilterDueDecendingKey";
NSString *const SDWListsShouldShowCardLabelsKey = @"com.sdwr.trello-mac.SDWListsShouldShowCardLabelsKey";
NSString *const SDWListsTrelloApiAppTokenKey = @"com.sdwr.trello-mac.SDWListsTrelloApiAppTokenKey";

@implementation Constants

@end
