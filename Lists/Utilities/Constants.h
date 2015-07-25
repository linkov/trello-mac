//
//  Constants.h
//  Lists
//
//  Created by alex on 5/16/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import <Foundation/Foundation.h>

/*misc*/

extern NSString *const SDWListsCardsListDragedTypesReorder;

/*notifications*/

extern NSString *const SDWListsDidReceiveUserTokenNotification;
extern NSString *const SDWListsDidChangeSidebarStatusNotification;
extern NSString *const SDWListsDidChangeCardDetailsStatusNotification;
extern NSString *const SDWListsDidChangeDotOptionNotification;

extern NSString *const SDWListsDidRemoveCardNotification;
extern NSString *const SDWListsShouldFilterNotification;
extern NSString *const SDWListsShouldCreateCardNotification;
extern NSString *const SDWListsDidUpdateDueNotification;

extern NSString *const SDWListsShouldReloadListNotification;
extern NSString *const SDWListsShouldReloadBoardsNotification;

/* defaults */
extern NSString *const SDWListsShouldUseCrownFilterKey;
extern NSString *const SDWListsShouldFilterDueAccendingKey;
extern NSString *const SDWListsShouldFilterDueDecendingKey;
extern NSString *const SDWListsShouldShowCardLabelsKey;
extern NSString *const SDWListsTrelloApiAppTokenKey;

@interface Constants : NSObject

@end
