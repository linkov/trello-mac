//
//  SDWBoardsController.h
//  Lists
//
//  Created by alex on 10/26/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDWBoardsController : NSViewController

@property (strong,nonatomic) NSColor *textColor;

- (void)loadBoards;
- (IBAction)reloadBoards:(id)sender;

@end
