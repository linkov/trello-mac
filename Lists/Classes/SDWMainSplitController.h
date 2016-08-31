//
//  SDWMainSplitController.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@class SDWBoardsController,SDWCardsController,SDWCardViewController, SDWBoard;
#import <Cocoa/Cocoa.h>
#import "Utils.h"


@interface SDWMainSplitController : NSSplitViewController


@property (strong) SDWCardsController *cardsVC;
@property (strong) SDWBoardsController *boardsVC;
@property (strong) SDWCardViewController *cardDetailsVC;

- (void)logout;


- (void)boardsListVCDidRequestBoardEdit:(SDWBoard *)board;
- (void)addItemVCDidFinishWithName:(NSString *)name didCancel:(BOOL)didCancel;
- (void)boardsListVCDidRequestAddItem;
- (void)boardsListVCDidRequestAddListToBoard:(SDWBoard *)board;

@end
