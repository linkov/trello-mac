//
//  SDWShortcutsManager.m
//  Lists
//
//  Created by alex on 11/25/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import "SDWShortcutsManager.h"

@implementation SDWShortcutsManager

+ (instancetype)sharedManager {
    static SDWShortcutsManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [SDWShortcutsManager new];
    });

    return _sharedManager;
}

- (void)handlekeyDown:(NSEvent *)theEvent {
    NSUInteger modifier = [theEvent modifierFlags];
    NSUInteger key = [theEvent keyCode];

    if (modifier == 1048840 && key == 15) { // CMD+R
        [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsShouldReloadListNotification object:nil];
    }

    if (modifier == 1179914 && key == 15) { // SHIFT+CMD+R
        [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsShouldReloadBoardsNotification object:nil];
    }

    if (modifier == 1048840 && key == 45) { // CMD+N
        [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsShouldCreateCardNotification object:nil];
    }
}

@end
