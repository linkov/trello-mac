//
//  SDWCardsCollectionViewItem.h
//  Vector
//
//  Created by alex on 10/31/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SDWCardsCollectionViewItem : NSCollectionViewItem
@property (weak) IBOutlet SDWCardListView *mainBox;
@property (strong) NSColor *textColor;

- (IBAction)setClr:(id)sender;

@end
