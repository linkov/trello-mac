//
//  LeftListView.m
//  Trellobyte
//
//  Created by alex on 10/18/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "NSColor+Util.h"
#import "LeftListView.h"

@implementation LeftListView

- (void)awakeFromNib {

    [self setAlphaValue:0.2];
}

- (void)drawRect:(NSRect)dirtyRect {
    // set any NSColor for filling, say white:

    NSColor *color = [NSColor colorWithHexColorString:@"afcddc"];
    [color  setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}


@end
