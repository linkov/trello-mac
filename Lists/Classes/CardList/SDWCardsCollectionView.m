//
//  SDWCardsCollectionView.m
//  Lists
//
//  Created by alex on 11/9/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
#import "SDWAppSettings.h"
#import "SDWCardsCollectionView.h"

@implementation SDWCardsCollectionView

- (void)keyDown:(NSEvent *)theEvent {


    NSUInteger modifier = [theEvent modifierFlags];
    NSUInteger key = [theEvent keyCode];

    if (modifier == 1048840 && key == 45) {

        [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsShouldCreateCardNotification object:nil];
    }

    if (modifier == 1048840 && key == 15) {
        [[NSNotificationCenter defaultCenter] postNotificationName:SDWListsShouldReloadListNotification object:nil];
    }

}

@end
