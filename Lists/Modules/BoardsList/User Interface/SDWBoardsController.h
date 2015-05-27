//
//  SDWBoardsController.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

@import Cocoa;
#import "SDWBoardsListUserInterface.h"
#import "SDWBoardsListModuleInterface.h"
#import "SDWBoardsListModuleDelegate.h"

@interface SDWBoardsController : NSViewController <SDWBoardsListUserInterface>

@property (strong, nonatomic) NSColor *textColor;

- (void)    loadBoards;
- (IBAction)reloadBoards:(id)sender;

@property (nonatomic, strong) id<SDWBoardsListModuleInterface> eventHandler;
@property (nonatomic, weak) id<SDWBoardsListModuleDelegate> moduleDelegate;

@end
