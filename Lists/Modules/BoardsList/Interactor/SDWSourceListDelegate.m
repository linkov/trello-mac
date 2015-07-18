//
//  SDWSourceListDelegate.m
//  experimentsCoreDataOutlineView
//
//  Created by alex on 5/17/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWSourceListDelegate.h"

/*-------View Controllers-------*/

/*-------Frameworks-------*/

/*-------Views-------*/
#import "SDWBoardsListRow.h"

/*-------Helpers & Managers-------*/
#import "SDWMacros.h"
#import "NSColor+AppColors.h"

/*-------Models-------*/
#import "SDWSourceListItem.h"

@interface SDWSourceListDelegate () <NSOutlineViewDelegate, NSTableViewDelegate>

@property NSArray *items;
@property (copy) SDWDataBlock didClickBlock;
@property SDWBoardsListRow *prevSelectedRow;
@property NSOutlineView *outlineView;

@end

@implementation SDWSourceListDelegate

- (instancetype)initWithItems:(NSArray *)items
                  outlineView:(NSOutlineView *)outlineView
            cellDidClickBlock:(SDWDataBlock)block {
    self = [super init];
    if (self) {
        self.items = items;
        self.didClickBlock = block;
        self.outlineView = outlineView;
    }
    return self;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id<SDWSourceListItem>)item {
    NSTableCellView *tableCellView = [outlineView makeViewWithIdentifier:@"BoardListCell" owner:self];
    tableCellView.textField.stringValue = [item itemName];
    tableCellView.textField.textColor = [NSColor appBleakWhiteColor];

    return tableCellView;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id<SDWSourceListItem>)item {
    if (item.isLeaf) {
        SDWPerformBlock(self.didClickBlock, item);
        return YES;
    }

    return NO;
}

- (NSTableRowView *)outlineView:(NSOutlineView *)outlineView rowViewForItem:(NSTreeNode *)item {
    SDWBoardsListRow *row = [SDWBoardsListRow new];
    return row;
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    if (self.outlineView.selectedRow == -1) {
        return;
    }

    self.prevSelectedRow.selected = NO;
    [self.prevSelectedRow setNeedsDisplay:YES];

    SDWBoardsListRow *selectedRow = (SDWBoardsListRow *)[self.outlineView rowViewAtRow:self.outlineView.selectedRow makeIfNecessary:YES];
    selectedRow.selected = YES;
    [selectedRow setNeedsDisplay:YES];

    self.prevSelectedRow = selectedRow;
}

@end
