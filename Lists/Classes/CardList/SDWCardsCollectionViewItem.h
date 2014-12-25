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


- (void)updateIndicators;

@end

@protocol SDWCardViewDelegate

@optional

- (void)cardViewShouldContainLabelColors:(NSString *)colors;
- (void)cardViewShouldRemoveLabelOfColor:(NSString *)color;
- (void)cardViewShouldDeselectCard:(SDWCardsCollectionViewItem *)cardView;
- (void)cardViewShouldSaveCard:(SDWCardsCollectionViewItem *)cardView;
- (void)cardViewShouldDismissCard:(SDWCardsCollectionViewItem *)cardView;
- (void)cardViewDidSelectCard:(SDWCardsCollectionViewItem *)cardView;


@end