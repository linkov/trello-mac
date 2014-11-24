//
//  SDWCardsCollectionView.m
//  Lists
//
//  Created by alex on 11/9/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWShortcutsManager.h"
#import "SDWAppSettings.h"
#import "SDWCardsCollectionView.h"

@implementation SDWCardsCollectionView


- (void)keyDown:(NSEvent *)theEvent {

    [[SDWShortcutsManager sharedManager] handlekeyDown:theEvent];
}

@end
