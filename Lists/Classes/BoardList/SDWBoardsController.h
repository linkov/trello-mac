//
//  SDWBoardsController.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SDWMainSplitController.h"

@class WSCBoardsOutlineView;

@interface SDWBoardsController : NSViewController
@property (strong) NSTreeNode *lastSelectedItem;
@property (strong,nonatomic) NSColor *textColor;
@property (weak) SDWMainSplitController *delegate;
@property (strong) IBOutlet WSCBoardsOutlineView *outlineView;

- (void)loadBoards;
- (IBAction)reloadBoards:(id)sender;
- (void)reloadLayout;

@end
