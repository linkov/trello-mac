//
//  SDWBoardsListRow.m
//  Lists
//
//  Created by alex on 11/5/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+AppColors.h"
#import "NSColor+Util.h"
#import "SDWBoardsListRow.h"

@implementation SDWBoardsListRow

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    NSRect separatorLine = NSRectFromCGRect(CGRectMake(0, self.bounds.size.height - 0.5, self.bounds.size.width, 0.5));
    [[NSColor appBackgroundColorDark] set];
    [NSBezierPath fillRect:separatorLine];
}

- (void)drawDraggingDestinationFeedbackInRect:(NSRect)dirtyRect {
    NSRect drawRect = NSInsetRect(self.bounds, 0, 0);
    [[NSColor appHighlightGreenColor] set];
    [NSBezierPath fillRect:drawRect];
}

- (void)drawSelectionInRect:(NSRect)dirtyRect {
    NSRect drawRect = NSInsetRect(self.bounds, 0, 0);
    [[NSColor appHighlightColor] set];
    [NSBezierPath fillRect:drawRect];
}

- (void)mouseDown:(NSEvent *)theEvent {
    [super mouseDown:theEvent];

    if (theEvent.clickCount >= 2) {
        [self.delegate boardRowDidDoubleClick:self];
    }
}

- (void)didAddSubview:(NSView *)subview {
    [super didAddSubview:subview];

    if ([subview isKindOfClass:[NSButton class]]) {
        [(NSButton *)subview setImage :[NSImage imageNamed:@"trian-closed"]];
        [(NSButton *)subview setAlternateImage :[NSImage imageNamed:@"trian-open"]];
    }
}

@end
