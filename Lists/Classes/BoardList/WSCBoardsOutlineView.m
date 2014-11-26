//
//  WSCBoardsOutlineView.m
//  Lists
//
//  Created by alex on 11/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWBoard.h"
#import "NSColor+Util.h"
#import "WSCBoardsOutlineView.h"

@interface WSCBoardsOutlineView ()

@property NSUInteger contextRow;

@end

@implementation WSCBoardsOutlineView

- (void)awakeFromNib {
    self.intercellSpacing = CGSizeMake(0, 5);
}

- (NSMenu*)menuForEvent:(NSEvent*)evt {

    NSPoint pt = [self convertPoint:[evt locationInWindow] fromView:nil];
    NSUInteger row = [self rowAtPoint:pt];

    SDWBoard *board =[self itemAtRow:row];
    if (board.isLeaf) {
        return [self defaultMenuForRow:row];
    }
    return nil;

}

- (NSMenu*)defaultMenuForRow:(NSUInteger)row {

    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"List menu"];

    [theMenu insertItemWithTitle:@"Delete"
                          action:@selector(removeList)
                   keyEquivalent:@""
                         atIndex:0];


    self.contextRow = row;

    return theMenu;
}

- (void)removeList {

    [self.menuDelegate outlineviewShouldDeleteListAtRow:self.contextRow];

}

- (void)addList {
    [self.menuDelegate outlineviewShouldAddListBelowRow:self.contextRow];

}


@end
