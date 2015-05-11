//
//  SDWSingleCardTableCellView.h
//  Lists
//
//  Created by alex on 2/11/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//
@class SDWCardListView;

#import <Cocoa/Cocoa.h>

@protocol SDWSingleCardViewDelegate;

@interface SDWSingleCardTableCellView : NSTableCellView <NSTextFieldDelegate>

@property (strong) IBOutlet NSStackView *stackView;
@property (strong) IBOutlet NSLayoutConstraint *widthConstraint;
@property (strong) IBOutlet SDWCardListView *mainBox;

@property (weak) id <SDWSingleCardViewDelegate> delegate;

@end

@protocol SDWSingleCardViewDelegate

@optional

- (void)cardViewShouldContainLabelColors:(NSString *)colors;
- (void)cardViewShouldRemoveLabelOfColor:(NSString *)color;
- (void)cardViewShouldDeselectCard:(SDWSingleCardTableCellView *)cardView;
- (void)cardViewShouldSaveCard:(SDWSingleCardTableCellView *)cardView;
- (void)cardViewShouldDismissCard:(SDWSingleCardTableCellView *)cardView;
- (void)cardViewDidSelectCard:(SDWSingleCardTableCellView *)cardView;

@end
