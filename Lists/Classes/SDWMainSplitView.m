//
//  SDWMainSplitView.m
//  Lists
//
//  Created by alex on 11/4/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "SDWAppSettings.h"
#import "SDWMainSplitView.h"

@implementation SDWMainSplitView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (NSColor*)dividerColor {
    return [SharedSettings appBackgroundColor];
}

- (void)keyDown:(NSEvent *)theEvent {


    NSUInteger modifier = [theEvent modifierFlags];
    NSUInteger key = [theEvent keyCode];

    //1179914

    if (modifier == 1048840 && key == 15) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsShouldReloadListNotification object:nil];
    }

    if (modifier == 1179914 && key == 15) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsShouldReloadBoardsNotification object:nil];
    }

    if (modifier == 1048840 && key == 45) {

        [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsShouldCreateCardNotification object:nil];
    }

}

@end
