//
//  SDWCardsCollectionView.m
//  Vector
//
//  Created by alex on 11/9/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import "SDWCardsCollectionView.h"

@implementation SDWCardsCollectionView

- (void)keyDown:(NSEvent *)theEvent {


    NSUInteger modifier = [theEvent modifierFlags];
    NSUInteger key = [theEvent keyCode];

    if (modifier == 1048840 && key == 45) {

        [[NSNotificationCenter defaultCenter] postNotificationName:@"com.sdwr.trello-mac.shouldCreateCardNotification" object:nil];
    }

        [super keyDown:theEvent];
}

@end
