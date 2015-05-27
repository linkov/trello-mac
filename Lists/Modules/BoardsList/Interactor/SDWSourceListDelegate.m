//
//  SDWSourceListDelegate.m
//  experimentsCoreDataOutlineView
//
//  Created by alex on 5/17/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWSourceListDelegate.h"
#import "SDWSourceListItem.h"

@interface SDWSourceListDelegate () <NSOutlineViewDelegate>

@property NSArray *items;

@end

@implementation SDWSourceListDelegate

- (instancetype)initWithItems:(NSArray *)items {
    self = [super init];
    if (self) {
        self.items = items;
    }
    return self;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id<SDWSourceListItem>)item {
    NSTableCellView *tableCellView = [outlineView makeViewWithIdentifier:@"BoardListCell" owner:self];
    tableCellView.textField.stringValue = [item itemName];

    return tableCellView;
}

@end
