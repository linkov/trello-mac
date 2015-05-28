//
//  SDWMainSplitController.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@class SDWBoardsController, SDWCardsController, SDWCardViewController;

#import "SDWRootModuleInterface.h"
#import "SDWRootUserInterface.h"
#import "SDWCardsListModuleDelegate.h"
#import "SDWBoardsListModuleDelegate.h"

@import Cocoa;

@interface SDWMainSplitController : NSSplitViewController <SDWRootUserInterface,SDWBoardsListModuleDelegate,SDWCardsListModuleDelegate>

@property (strong) SDWCardsController *cardsVC;
@property (strong) SDWBoardsController *boardsVC;
@property (strong) SDWCardViewController *cardDetailsVC;

- (void)logout;

@property (nonatomic, strong) id<SDWRootModuleInterface> eventHandler;

@end
