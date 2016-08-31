//
//  SDWBoardsController.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SDWMainSplitController.h"

@interface SDWBoardsController : NSViewController

@property (strong,nonatomic) NSColor *textColor;
@property (weak) SDWMainSplitController *delegate;

- (void)loadBoards;
- (IBAction)reloadBoards:(id)sender;

@end
