//
//  SDWCardsCollectionViewItem.h
//  Vector
//
//  Created by alex on 10/31/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@class SDWCardListView;
#import <Cocoa/Cocoa.h>

@interface SDWCardsCollectionViewItem : NSCollectionViewItem
@property (weak) IBOutlet SDWCardListView *mainBox;
@property (strong) NSColor *textColor;

- (void)expand;

@end
