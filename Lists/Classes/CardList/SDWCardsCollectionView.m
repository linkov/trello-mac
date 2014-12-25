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
#import "SDWCardsCollectionViewItem.h"
@implementation SDWCardsCollectionView


- (void)keyDown:(NSEvent *)theEvent {

    [[SDWShortcutsManager sharedManager] handlekeyDown:theEvent];

}


- (NSCollectionViewItem *)newItemForRepresentedObject:(id)object {

    SDWCardsCollectionViewItem *item =  (SDWCardsCollectionViewItem *)[super newItemForRepresentedObject:object];
    item.delegate = (id)self.delegate;

    return item;

}


@end
