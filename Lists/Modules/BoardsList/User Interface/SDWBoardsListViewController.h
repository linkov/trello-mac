//
//  SDWBoardsListViewController.h
//  Lists
//
//  Created by alex on 5/26/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

@import AppKit;
@import Cocoa;
#import "SDWBoardsListUserInterface.h"
#import "SDWBoardsListModuleInterface.h"
#import "SDWBoardsListModuleDelegate.h"

@interface SDWBoardsListViewController : NSViewController <SDWBoardsListUserInterface>

@property (nonatomic, strong) id<SDWBoardsListModuleInterface> eventHandler;
@property (nonatomic, weak) id<SDWBoardsListModuleDelegate> moduleDelegate;

@end
