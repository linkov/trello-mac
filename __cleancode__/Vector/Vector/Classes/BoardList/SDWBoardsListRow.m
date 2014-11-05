//
//  SDWBoardsListRow.m
//  Vector
//
//  Created by alex on 11/5/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+Util.h"
#import "SDWBoardsListRow.h"

@implementation SDWBoardsListRow

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    NSRect drawRect = NSInsetRect(self.bounds, 0, 0);

    if (self.selected) {
        [[NSColor colorWithHexColorString:@"3E6378"] set];
    }
    else  {
        [[NSColor colorWithHexColorString:@"1E5676"] set];

    }

    [NSBezierPath fillRect:drawRect];
}

- (NSBackgroundStyle)interiorBackgroundStyle {

    return NSBackgroundStyleDark;
}

- (void)drawSelectionInRect:(NSRect)dirtyRect {


    NSRect drawRect = NSInsetRect(self.bounds, 0, 0);
    [[NSColor redColor] set];
    [NSBezierPath fillRect:drawRect];
        [super drawSelectionInRect:dirtyRect];
}

@end
