//
//  WSCBoardsOutlineView.m
//  Lists
//
//  Created by alex on 11/1/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+Util.h"
#import "WSCBoardsOutlineView.h"

@interface WSCBoardsOutlineView ()
@end

@implementation WSCBoardsOutlineView

- (void)awakeFromNib {
    self.intercellSpacing = CGSizeMake(0, 5);
}

-(NSMenu*)menuForEvent:(NSEvent*)evt
{
    NSPoint pt = [self convertPoint:[evt locationInWindow] fromView:nil];
    NSUInteger row = [self rowAtPoint:pt];
    return [self defaultMenuForRow:row];
}

-(NSMenu*)defaultMenuForRow:(NSUInteger)row {

    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"List menu"];

    [theMenu insertItemWithTitle:@"Delete"
                          action:@selector(removeList:)
                   keyEquivalent:@""
                         atIndex:0];


    self.contextRow = row;

    return theMenu;
}

- (void)removeList:(id)sender {

    [self.menuDelegate outlineviewShouldDelete:self];

}


@end
