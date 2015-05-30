//
//  SDWCardsListDelegate.m
//  Lists
//
//  Created by alex on 5/27/15.
//  Copyright (c) 2015 SDWR. All rights reserved.
//

#import "SDWCardsListDelegate.h"
#import "SDWCardsListRow.h"

@interface SDWCardsListDelegate ()

@property NSArray *items;

@end

@implementation SDWCardsListDelegate

- (instancetype)initWithItems:(NSArray *)items
                  returnBlock:(SDWCellItemBlock)returnBlock
              rightClickBlock:(SDWCellItemBlock)rightClick {
    self = [super init];
    if (self) {
        self.items = items;
    }

    return self;
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    SDWCardsListRow *rowView = [SDWCardsListRow new];

    return rowView;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectSection:(NSInteger)section {
    return YES;
}

- (BOOL)_jwcTableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard *)pboard {
    return NO;
}

- (NSDragOperation)_jwcTableView:(NSTableView *)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op {
    return NSDragOperationNone;
}

- (BOOL)_jwcTableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
                  row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation {
    return NO;
}

- (void)_jwcTableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forRowIndexes:(NSIndexSet *)rowIndexes {
}

- (void)_jwcTableView:(NSTableView *)tableView draggingSession:(NSDraggingSession *)session endedAtPoint:(NSPoint)screenPoint operation:(NSDragOperation)operation {
}

@end
