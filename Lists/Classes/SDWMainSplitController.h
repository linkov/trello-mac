//
//  SDWMainSplitController.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@class SDWBoardsController,SDWCardsController,SDWCardViewController;
#import <Cocoa/Cocoa.h>

@interface SDWMainSplitController : NSSplitViewController


@property (strong) SDWCardsController *cardsVC;
@property (strong) SDWBoardsController *boardsVC;
@property (strong) SDWCardViewController *cardDetailsVC;

- (void)logout;

@end