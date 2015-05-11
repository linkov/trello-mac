//
//  SDWMainSplitView.m
//  Lists
//
//  Created by alex on 11/4/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWShortcutsManager.h"
#import "SDWAppSettings.h"
#import "SDWMainSplitView.h"

@implementation SDWMainSplitView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    // Drawing code here.
}

- (NSColor *)dividerColor {
    return [SharedSettings appBackgroundColor];
}

- (void)keyDown:(NSEvent *)theEvent {
    [[SDWShortcutsManager sharedManager] handlekeyDown:theEvent];
}

@end
