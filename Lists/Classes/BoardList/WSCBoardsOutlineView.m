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
        return nil;
//        return [self listMenuForRow:row];
    } else {
        return [self boardMenuForRow:row];
    }
    return nil;

}

- (NSMenu*)listMenuForRow:(NSUInteger)row {

    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"List menu"];

    [theMenu insertItemWithTitle:@"Close list"
                          action:@selector(removeList)
                   keyEquivalent:@""
                         atIndex:0];


    self.contextRow = row;

    return theMenu;
}


- (NSMenu*)boardMenuForRow:(NSUInteger)row {

    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Board menu"];

    [theMenu insertItemWithTitle:@"Close board"
                          action:@selector(removeBoard)
                   keyEquivalent:@""
                         atIndex:0];
    [theMenu insertItemWithTitle:@"Rename board"
                          action:@selector(editBoard)
                   keyEquivalent:@""
                         atIndex:1];


    self.contextRow = row;

    return theMenu;
}


- (void)editBoard {
    [self.menuDelegate outlineviewShouldEditBoardAtRow:self.contextRow];
}

- (void)removeBoard {

    [self.menuDelegate outlineviewShouldDeleteBoardAtRow:self.contextRow];
    
}



- (void)removeList {

    [self.menuDelegate outlineviewShouldDeleteListAtRow:self.contextRow];

}

//- (void)addList {
//    [self.menuDelegate outlineviewShouldAddListBelowRow:self.contextRow];
//
//}


@end
