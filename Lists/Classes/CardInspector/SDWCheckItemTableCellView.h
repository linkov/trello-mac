//
//  SDWCheckItemTableCellView.h
//  Lists
//
//  Created by alex on 1/4/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//
@class SDWCheckItemTableCellView,SDWChecklistItemDisplayItem,SDWChecklistDisplayItem;

#import <Cocoa/Cocoa.h>
#import "AAPLCheckBox.h"

@protocol SDWCheckItemDelegate

@optional

- (void)checkItemShouldAddItem:(SDWCheckItemTableCellView *)itemView;
- (void)checkItemDidCheck:(SDWCheckItemTableCellView *)itemView;
- (void)checkItemDidChangeName:(SDWCheckItemTableCellView *)itemView;

@end

@interface SDWCheckItemTableCellView : NSTableCellView

@property (strong) IBOutlet AAPLCheckBox *checkBox;
@property (strong) IBOutlet NSLayoutConstraint *centerYConstraint;
@property (weak) id<SDWCheckItemDelegate> delegate;
@property (strong) SDWChecklistItemDisplayItem *trelloCheckItem;
@property (strong,nonatomic) NSString *trelloCheckListID;
@property (strong) IBOutlet NSLayoutConstraint *checkBoxWidth;
@property (strong) IBOutlet NSLayoutConstraint *addCheckItemWidth;
@property (strong) IBOutlet NSLayoutConstraint *addCheckItemCenterY;
@property (strong) IBOutlet NSLayoutConstraint *checkItemTopSpace;
@property (strong) IBOutlet NSLayoutConstraint *checkItemWidth;
@property (strong) IBOutlet NSLayoutConstraint *addCheckTrailing;
@property (strong) IBOutlet NSLayoutConstraint *addCheckLeading;
@property (strong) IBOutlet NSLayoutConstraint *handleCenterY;

- (void)animateControlsOpacityIn:(BOOL)shouldShow;

@end
