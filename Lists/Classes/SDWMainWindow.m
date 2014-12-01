//
//  SDWMainWindow.m
//  Lists
//
//  Created by alex on 11/25/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWShortcutsManager.h"
#import "SDWMainWindow.h"

@implementation SDWMainWindow


- (void)keyDown:(NSEvent *)theEvent {

    [[SDWShortcutsManager sharedManager] handlekeyDown:theEvent];
}


// TODO: make code less opaque (http://www.sluse.com/view/20507457)
- (void)sendEvent:(NSEvent *)theEvent {

    /*
     3 finger multi-touch tap causes crash in [LULookupDefinitionModule _focusTermUsingQueue:handler:]
     so we block it
     */
    if (theEvent.type == NSSystemDefined && theEvent.subtype == 9) {

    } else {

        [super sendEvent:theEvent];
    }
}


@end
