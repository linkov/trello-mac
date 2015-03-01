//
//  SDWSingleCardTableCellView.h
//  Lists
//
//  Created by alex on 2/11/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//
@class SDWCardListView;

#import <Cocoa/Cocoa.h>

@interface SDWSingleCardTableCellView : NSTableCellView
@property (weak) IBOutlet NSTextField *textField;
@property (strong) IBOutlet NSStackView *stackView;
@property (strong) IBOutlet NSLayoutConstraint *widthConstraint;
@property (strong) IBOutlet SDWCardListView *mainBox;

@end
