//
//  CardListView.m
//  Trellobyte
//
//  Created by alex on 10/19/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "Xtrace.h"
#import "CardListView.h"

@implementation CardListView 

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    NSRect drawRect = NSInsetRect(self.bounds, 5, 5);

    if (self.selected)
    {
        [[NSColor blueColor] set];
        [NSBezierPath strokeRect:drawRect];
    }
}

#pragma mark Properties

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay:YES];
}

@end
