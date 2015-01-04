//
//  SDWCheckItemTableCellView.h
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//
@class SDWCheckItemTableCellView,SDWChecklistItem;

#import <Cocoa/Cocoa.h>
#import "AAPLCheckBox.h"

@protocol SDWCheckItemDelegate

@optional

- (void)checkItemDidCheck:(SDWCheckItemTableCellView *)item;

@end

@interface SDWCheckItemTableCellView : NSTableCellView

@property (strong) IBOutlet AAPLCheckBox *checkBox;
@property (strong) IBOutlet NSLayoutConstraint *centerYConstraint;
@property (weak) id<SDWCheckItemDelegate> delegate;
@property (strong) SDWChecklistItem *trelloCheckItem;

@end
