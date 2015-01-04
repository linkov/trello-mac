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

/* trash quicklook event b/c it causes crash  */
- (void)quickLookWithEvent:(NSEvent *)event {}


@end
