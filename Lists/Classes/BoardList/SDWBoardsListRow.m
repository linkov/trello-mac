//
//  SDWBoardsListRow.m
//  Lists
//
//  Created by alex on 11/5/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import "NSColor+Util.h"
#import "SDWBoardsListRow.h"

@implementation SDWBoardsListRow

//- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
//
//    NSRect drawRect = NSInsetRect(self.bounds, 0, 0);
//    [[SharedSettings appBackgroundColorDark] set];
//    [NSBezierPath fillRect:drawRect];
//}

- (void)drawDraggingDestinationFeedbackInRect:(NSRect)dirtyRect {

    NSRect drawRect = NSInsetRect(self.bounds, 0, 0);
    [[SharedSettings appHighlightGreenColor] set];
    [NSBezierPath fillRect:drawRect];
}

- (void)drawSelectionInRect:(NSRect)dirtyRect {

    NSRect drawRect = NSInsetRect(self.bounds, 0, 0);
    [[SharedSettings appHighlightColor] set];
    [NSBezierPath fillRect:drawRect];

}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];

    if (theEvent.clickCount >= 2) {
        [self.delegate boardRowDidDoubleClick:self];

    }
}

-(void)didAddSubview:(NSView *)subview {
    [super didAddSubview:subview];

    if ( [subview isKindOfClass:[NSButton class]] ) {
        [(NSButton *)subview setImage:[NSImage imageNamed:@"trian-closed"]];
        [(NSButton *)subview setAlternateImage:[NSImage imageNamed:@"trian-open"]];
    }
}


@end
