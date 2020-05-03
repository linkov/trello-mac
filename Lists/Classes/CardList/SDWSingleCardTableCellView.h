//
//  SDWSingleCardTableCellView.h
//  Lists
//
//  Created by alex on 2/11/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//
@class SDWCardListView, SDWCardDisplayItem;

#import <Cocoa/Cocoa.h>

@protocol SDWSingleCardViewDelegate;

@interface SDWSingleCardTableCellView : NSTableCellView <NSTextFieldDelegate>

@property Boolean menuClickEnabled;

@property (strong) IBOutlet NSStackView *stackView;
@property (strong) IBOutlet NSLayoutConstraint *widthConstraint;
@property (strong) IBOutlet SDWCardListView *mainBox;
@property (weak) IBOutlet NSStackView *customLabelsView;
@property (weak) IBOutlet NSLayoutConstraint *customLabelsViewHeightConstaint;
@property (weak) IBOutlet NSLayoutConstraint *commentsIconWidth;
@property (weak) IBOutlet NSTextField *commentsCountTextfield;
@property (weak) IBOutlet NSImageView *commentsIconImageView;

@property (weak) id <SDWSingleCardViewDelegate> delegate;

@property (strong) NSString *boardID;
@property (strong) SDWCardDisplayItem *cardDisplayItem;
@property (weak) IBOutlet NSLayoutConstraint *mainTextfieldTrailingConstraint;

@end


@protocol SDWSingleCardViewDelegate

@optional

- (void)cardViewShouldRemoveUser:(NSString *)trelloID;
- (void)cardViewShouldAddUser:(NSString *)trelloID;

- (void)cardViewShouldRemoveLabelOfColor:(NSString *)color;
- (void)cardViewShouldAddLabelOfColor:(NSString *)color;
- (void)cardViewShouldDeselectCard:(SDWSingleCardTableCellView *)cardView;
- (void)cardViewShouldSaveCard:(SDWSingleCardTableCellView *)cardView;
- (void)cardViewShouldDismissCard:(SDWSingleCardTableCellView *)cardView;
- (void)cardViewDidSelectCard:(SDWSingleCardTableCellView *)cardView;


@end
