//
//  CardListView.m
//  Trellobyte
//
//  Created by alex on 10/19/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+Util.h"
#import "Xtrace.h"
#import "CardListView.h"

@implementation CardListView 

- (void)drawRect:(NSRect)dirtyRect {
    // Drawing code here.
    NSRect drawRect = NSInsetRect(self.bounds, 0, 0);

    if (self.selected)
    {
        [[NSColor colorWithHexColorString:@"0099CC"] set];
   }
    else {

        [[NSColor clearColor] set];
    }

    [NSBezierPath fillRect:drawRect];
}


- (void)layoutSubtreeIfNeeded {

    [super layoutSubtreeIfNeeded];
    
}

- (void)viewDidMoveToSuperview {

}

#pragma mark - Properties

- (void)setSelected:(BOOL)selected
{
    _selected = selected;

    [self setNeedsDisplay:YES];
}


@end
