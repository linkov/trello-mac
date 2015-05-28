//
//  SDWSourceListDelegate.m
//  experimentsCoreDataOutlineView
//
//  Created by alex on 5/17/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWSourceListDelegate.h"
#import "SDWSourceListItem.h"
#import "SDWMacros.h"

@interface SDWSourceListDelegate () <NSOutlineViewDelegate>

@property NSArray *items;
@property (copy) SDWDataBlock didClickBlock;

@end

@implementation SDWSourceListDelegate

- (instancetype)initWithItems:(NSArray *)items
            cellDidClickBlock:(SDWDataBlock)block {
    self = [super init];
    if (self) {
        self.items = items;
        self.didClickBlock = block;
    }
    return self;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id<SDWSourceListItem>)item {
    NSTableCellView *tableCellView = [outlineView makeViewWithIdentifier:@"BoardListCell" owner:self];
    tableCellView.textField.stringValue = [item itemName];

    return tableCellView;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id<SDWSourceListItem>)item {
    if (item.isLeaf) {
        SDWPerformBlock(self.didClickBlock, item);
        return YES;
    }

    return NO;
}

@end
