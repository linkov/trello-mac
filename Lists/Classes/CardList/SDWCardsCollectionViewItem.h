//
//  SDWCardsCollectionViewItem.h
//  Lists
//
//  Created by alex on 10/31/14.
//  Copyright (c) 2014 SDWR. All rights reserved.
//
@class SDWCardListView;
#import <Cocoa/Cocoa.h>


@protocol SDWCardViewDelegate;

@interface SDWCardsCollectionViewItem : NSCollectionViewItem
@property (weak) IBOutlet SDWCardListView *mainBox;
@property (strong) NSColor *textColor;
@property (strong) IBOutlet NSStackView *stackView;

@property (weak) id <SDWCardViewDelegate> delegate;

@end

@protocol SDWCardViewDelegate

@optional

- (void)cardViewDidReceiveDoubleClick:(SDWCardsCollectionViewItem *)cardView;
- (void)cardViewShouldSaveCard:(SDWCardsCollectionViewItem *)cardView;
- (void)cardViewShouldDismissCard:(SDWCardsCollectionViewItem *)cardView;


@end